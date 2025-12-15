/* =========================================================
   STAGE 3: FEATURE ENGINEERING
   ---------------------------------------------------------
   Purpose:
   Transform raw data into meaningful features for fraud detection.
   Key steps:
     • Derive customer age, account tenure, and transaction day
     • Calculate transaction-to-income ratios
     • Create flags for high-value transactions
     • Aggregate transactions per day or per customer
     • Generate Combine_Key for joining later in scoring
========================================================= */

-- 1️⃣ Add transaction date and day-of-week for temporal analysis
SELECT
    Transaction_ID,
    Customer_ID,
    Transaction_Amount,
    Transaction_Timestamp,
    CAST(Transaction_Timestamp AS DATE) AS Transaction_Date,
    DATENAME(WEEKDAY, Transaction_Timestamp) AS Transaction_Weekday,
    Merchant_Category,
    Transaction_State,
    Transaction_Channel
INTO #Transactions_Features
FROM FraudDB_Transactions;

-- 2️⃣ Join customer profile to enrich transactions
SELECT
    tf.*,
    c.Income,
    c.Card_Type,
    c.State AS Registered_State,
    c.Account_Tenure_Years,
    DATEDIFF(MONTH, c.Join_Date, tf.Transaction_Timestamp) AS Account_Age_Months,
    ROUND(tf.Transaction_Amount / NULLIF(c.Income,0),3) AS Txn_to_Income_Ratio
INTO #Transactions_Features_Enriched
FROM #Transactions_Features tf
JOIN Customer_Profile c
    ON tf.Customer_ID = c.Customer_ID;

-- 3️⃣ Flag high-value transactions (absolute and income-relative thresholds)
SELECT *,
    CASE 
        WHEN Transaction_Amount > 5000 OR Txn_to_Income_Ratio > 0.15 THEN 1
        ELSE 0
    END AS High_Value_Flag
INTO #Transactions_Features_Flagged
FROM #Transactions_Features_Enriched;

-- 4️⃣ Aggregate transactions per customer per day for behavioral features
SELECT
    Customer_ID,
    Transaction_Date,
    COUNT(*) AS Same_Day_Transactions,
    SUM(Transaction_Amount) AS Total_Spent_That_Day,
    MAX(Transaction_Amount) AS Max_Txn_Amount,
    MAX(Transaction_Timestamp) AS LastTxnTimestamp
INTO #Customer_Daily_Aggregates
FROM #Transactions_Features_Flagged
GROUP BY Customer_ID, Transaction_Date;

-- 5️⃣ Generate Combine_Key for transaction-level joins
SELECT *,
    CONCAT(Customer_ID, '|', Transaction_ID) AS Combine_Key_Transaction,
    CONCAT(Customer_ID, '|', Transaction_Date) AS Combine_Key_Day
INTO #Customer_Daily_Aggregates_Keys
FROM #Customer_Daily_Aggregates;

-- 6️⃣ Optional: flag customers with bursty activity (behavioral)
SELECT *,
    CASE 
        WHEN Same_Day_Transactions >= 3 OR Max_Txn_Amount > 6000 OR Max_Txn_Amount / NULLIF(Income,0) > 0.15 THEN 1
        ELSE 0
    END AS Behavioral_Burst_Flag
INTO #Customer_Behavioral_Features
FROM #Customer_Daily_Aggregates_Keys cda
JOIN Customer_Profile c
    ON cda.Customer_ID = c.Customer_ID;

-- 7️⃣ Quick checks
SELECT TOP 20 * FROM #Transactions_Features_Flagged ORDER BY Transaction_Amount DESC;
SELECT TOP 20 * FROM #Customer_Behavioral_Features ORDER BY Total_Spent_That_Day DESC;
