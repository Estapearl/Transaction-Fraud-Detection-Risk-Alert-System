/* =====================================================================
   STAGE 5: RULE-BASED FRAUD SCORING & ALERT GENERATION

   This stage applies business-driven fraud rules to transaction
   and customer data in order to detect suspicious behavior.
   Each rule captures a different fraud signal, and multiple
   rule hits increase overall fraud risk.
===================================================================== */

------------------------------------------------------------
-- RULE 1: CROSS-STATE HIGH-VALUE TRANSACTIONS
------------------------------------------------------------
-- Flags high-value transactions performed in a different
-- state from the customer’s registered location.
-- This helps detect possible card misuse or account takeover,
-- especially for newly opened accounts.

IF OBJECT_ID('tempdb..#Rule_CrossState') IS NOT NULL DROP TABLE #Rule_CrossState;

SELECT
    t.Customer_ID,
    t.Transaction_ID,
    CONCAT(t.Customer_ID, '|', t.Transaction_ID) AS Combine_Key,
    'CrossState_HighValue' AS Rule_Source
INTO #Rule_CrossState
FROM FraudDB_MasterView t
JOIN Customer_Profile c
    ON t.Customer_ID = c.Customer_ID
WHERE
    t.Transaction_State <> c.State
    AND DATEDIFF(MONTH, c.Join_Date, t.Transaction_Timestamp) <= 6
    AND (
        t.Transaction_Amount > 4000
        OR t.Transaction_Amount > 0.15 * c.Income
    );

------------------------------------------------------------
-- RULE 2: NEW ACCOUNT HIGH SPENDING
------------------------------------------------------------
-- Identifies newly opened accounts making unusually
-- large transactions early in their lifecycle.
-- Fraudulent or mule accounts often attempt high spending
-- shortly after account creation.

IF OBJECT_ID('tempdb..#Rule_NewAccountSpend') IS NOT NULL DROP TABLE #Rule_NewAccountSpend;

SELECT
    t.Customer_ID,
    t.Transaction_ID,
    CONCAT(t.Customer_ID, '|', t.Transaction_ID) AS Combine_Key,
    'NewAccount_HighSpend' AS Rule_Source
INTO #Rule_NewAccountSpend
FROM FraudDB_MasterView t
JOIN Customer_Profile c
    ON t.Customer_ID = c.Customer_ID
WHERE
    DATEDIFF(MONTH, c.Join_Date, t.Transaction_Timestamp) <= 6
    AND (
        t.Transaction_Amount > 7000
        OR t.Transaction_Amount > 0.15 * c.Income
    );

------------------------------------------------------------
-- RULE 3: BEHAVIORAL BURST ACTIVITY (CUSTOMER-DAY LEVEL)
------------------------------------------------------------
-- Detects abnormal transaction bursts within a single day,
-- such as multiple transactions or unusually high amounts.
-- This pattern often indicates rapid account draining attempts
-- rather than normal customer behavior.

IF OBJECT_ID('tempdb..#Rule_BehavioralBurst') IS NOT NULL DROP TABLE #Rule_BehavioralBurst;

WITH Customer_Daily_Activity AS (
    SELECT
        Customer_ID,
        CAST(Transaction_Timestamp AS DATE) AS Transaction_Date,
        COUNT(*) AS Daily_Transaction_Count,
        MAX(Transaction_Amount) AS Max_Transaction_Amount,
        MAX(Transaction_Timestamp) AS Last_Transaction_Time
    FROM FraudDB_Transactions
    GROUP BY Customer_ID, CAST(Transaction_Timestamp AS DATE)
)
SELECT
    d.Customer_ID,
    CONCAT(d.Customer_ID, '|', d.Transaction_Date) AS Combine_Key,
    'Behavioral_Burst' AS Rule_Source
INTO #Rule_BehavioralBurst
FROM Customer_Daily_Activity d
JOIN Customer_Profile c
    ON d.Customer_ID = c.Customer_ID
WHERE
    DATEDIFF(MONTH, c.Join_Date, d.Last_Transaction_Time) <= 6
    AND (
        d.Daily_Transaction_Count >= 3
        OR d.Max_Transaction_Amount > 6000
        OR d.Max_Transaction_Amount > 0.15 * c.Income
    );

------------------------------------------------------------
-- COMBINE ALL RULE TRIGGERS
------------------------------------------------------------
-- Merges outputs from all fraud rules into a single table
-- to support scoring and multi-rule risk evaluation.

IF OBJECT_ID('tempdb..#All_Fraud_Rules') IS NOT NULL DROP TABLE #All_Fraud_Rules;

SELECT Customer_ID, Combine_Key, Rule_Source
INTO #All_Fraud_Rules
FROM (
    SELECT * FROM #Rule_CrossState
    UNION ALL
    SELECT * FROM #Rule_NewAccountSpend
    UNION ALL
    SELECT * FROM #Rule_BehavioralBurst
) r;

------------------------------------------------------------
-- FRAUD SCORING & RISK CLASSIFICATION
------------------------------------------------------------
-- Assigns a fraud score based on how many distinct
-- rules were triggered for each transaction or customer-day.
-- Higher scores indicate higher investigation priority.

IF OBJECT_ID('tempdb..#Fraud_Scoring') IS NOT NULL DROP TABLE #Fraud_Scoring;

SELECT
    Customer_ID,
    Combine_Key,
    COUNT(DISTINCT Rule_Source) AS Fraud_Score
INTO #Fraud_Scoring
FROM #All_Fraud_Rules
GROUP BY Customer_ID, Combine_Key;

------------------------------------------------------------
-- FINAL FRAUD ALERT OUTPUT
------------------------------------------------------------
-- Produces the final fraud alert view with risk levels
-- (Low, Medium, High) to support analyst investigation
-- and operational fraud monitoring.

SELECT
    fs.Customer_ID,
    fs.Combine_Key,
    fs.Fraud_Score,
    STRING_AGG(ar.Rule_Source, '; ') AS Rules_Triggered,
    CASE
        WHEN fs.Fraud_Score >= 2 THEN 'HIGH RISK'
        WHEN fs.Fraud_Score = 1 THEN 'MEDIUM RISK'
        ELSE 'LOW RISK'
    END AS Fraud_Risk_Level
FROM #Fraud_Scoring fs
JOIN #All_Fraud_Rules ar
    ON fs.Combine_Key = ar.Combine_Key
GROUP BY fs.Customer_ID, fs.Combine_Key, fs.Fraud_Score
ORDER BY fs.Fraud_Score DESC;
