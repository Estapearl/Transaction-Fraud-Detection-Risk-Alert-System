/* =========================================================
   STAGE 4: RULE-BASED FRAUD DETECTION
   ---------------------------------------------------------
   Purpose:
   Apply business and behavioral rules to detect potential fraud.
   Each rule creates a table with flagged cases:
     • Rule 1: Cross-State Spend Risk
     • Rule 2: New Account High Spend
     • Rule 3: Behavioral Burst (multiple high transactions/day)
   Combine_Key is generated for joining and scoring later.
========================================================= */

-- ================================
-- RULE 1: CROSS-STATE SPEND RISK
-- Flags transactions where:
--  • Transaction state != registered state
--  • Transaction is high-value (absolute or income-relative)
-- Only for new customers (≤ 6 months)
-- ================================

IF OBJECT_ID('tempdb..#CrossState_SpendRisk') IS NOT NULL
    DROP TABLE #CrossState_SpendRisk;

SELECT
    t.Customer_ID,
    t.Transaction_ID,
    t.Transaction_Amount,
    t.Transaction_Timestamp,
    t.Merchant_Category,
    t.Transaction_State,
    c.Income,
    c.Card_Type,
    c.State AS Registered_State,
    DATEDIFF(MONTH, c.Join_Date, t.Transaction_Timestamp) AS Account_Age_Months,
    'Rule1_CrossState_SpendRisk' AS Rule_Source,
    CONCAT(t.Customer_ID, '|', CAST(t.Transaction_ID AS VARCHAR(20))) AS Combine_Key
INTO #CrossState_SpendRisk
FROM FraudDB_MasterView t
JOIN Customer_Profile c
    ON t.Customer_ID = c.Customer_ID
WHERE t.Transaction_State <> c.State
  AND DATEDIFF(MONTH, c.Join_Date, t.Transaction_Timestamp) <= 6
  AND (t.Transaction_Amount > 4000 OR t.Transaction_Amount > 0.15 * c.Income);

-- ================================
-- RULE 2: NEW ACCOUNT HIGH SPEND
-- Flags high-value transactions by customers ≤ 6 months old
-- ================================

IF OBJECT_ID('tempdb..#NewAccount_SpendRisk') IS NOT NULL
    DROP TABLE #NewAccount_SpendRisk;

SELECT
    c.Customer_ID,
    t.Transaction_ID,
    t.Transaction_Amount,
    t.Transaction_Timestamp,
    t.Merchant_Category,
    c.Income,
    DATEDIFF(MONTH, c.Join_Date, t.Transaction_Timestamp) AS Account_Age_Months,
    'Rule2_NewAccount_SpendRisk' AS Rule_Source,
    CONCAT(c.Customer_ID, '|', CAST(t.Transaction_ID AS VARCHAR(20))) AS Combine_Key
INTO #NewAccount_SpendRisk
FROM Customer_Profile c
JOIN FraudDB_MasterView t
    ON c.Customer_ID = t.Customer_ID
WHERE DATEDIFF(MONTH, c.Join_Date, t.Transaction_Timestamp) <= 6
  AND (t.Transaction_Amount > 7000 OR t.Transaction_Amount > 0.15 * c.Income);

-- ================================
-- RULE 3: BEHAVIORAL BURST
-- Flags customers making multiple high-value transactions
-- on the same day or very large transactions relative to income
-- Only for new customers (≤ 6 months)
-- ================================

IF OBJECT_ID('tempdb..#Rule3_BehavioralModel') IS NOT NULL
    DROP TABLE #Rule3_BehavioralModel;

WITH per_customer_day AS (
    SELECT
        Customer_ID,
        CAST(Transaction_Timestamp AS DATE) AS Transaction_Date,
        COUNT(*) AS Same_Day_Transactions,
        MAX(Transaction_Amount) AS Max_Txn_Amount,
        SUM(Transaction_Amount) AS Total_Spent_That_Day,
        MAX(Transaction_Timestamp) AS LastTxnTimestamp
    FROM FraudDB_Transactions
    GROUP BY Customer_ID, CAST(Transaction_Timestamp AS DATE)
)
SELECT
    pcd.Customer_ID,
    pcd.Transaction_Date,
    pcd.Same_Day_Transactions,
    pcd.Max_Txn_Amount,
    pcd.Total_Spent_That_Day,
    c.Income,
    c.Card_Type,
    DATEDIFF(MONTH, c.Join_Date, pcd.LastTxnTimestamp) AS Account_Age_Months,
    ROUND(pcd.Max_Txn_Amount / NULLIF(c.Income,0),3) AS Txn_to_Income_Ratio,
    'Rule3_BehavioralModel' AS Rule_Source,
    CONCAT(pcd.Customer_ID, '|', CONVERT(VARCHAR(10), pcd.Transaction_Date, 120)) AS Combine_Key
INTO #Rule3_BehavioralModel
FROM per_customer_day pcd
JOIN Customer_Profile c
    ON pcd.Customer_ID = c.Customer_ID
WHERE DATEDIFF(MONTH, c.Join_Date, pcd.LastTxnTimestamp) <= 6
  AND (pcd.Same_Day_Transactions >= 3 OR pcd.Max_Txn_Amount > 6000 OR pcd.Max_Txn_Amount > 0.15 * NULLIF(c.Income,0));

-- ================================
-- QUICK PREVIEWS
-- Verify flagged cases
-- ================================
SELECT TOP 20 * FROM #CrossState_SpendRisk ORDER BY Transaction_Amount DESC;
SELECT TOP 20 * FROM #NewAccount_SpendRisk ORDER BY Transaction_Amount DESC;
SELECT TOP 20 * FROM #Rule3_BehavioralModel ORDER BY Total_Spent_That_Day DESC;
