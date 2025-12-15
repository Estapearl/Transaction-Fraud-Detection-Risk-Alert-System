/* =========================================================
   STAGE 2: EXPLORATORY DATA ANALYSIS (EDA)
   ---------------------------------------------------------
   Purpose:
   This stage helps understand transaction patterns and 
   customer behavior, which is critical for designing 
   fraud detection rules. Key analyses include:
     • Transaction distribution by amount, state, and merchant
     • Customer distribution by income, tenure, and location
     • Frequency of transactions per customer
     • Identifying high-value transactions
     • Insights for setting rule thresholds
========================================================= */

-- 1️⃣ Transaction amount distribution (summary statistics)
SELECT 
    MIN(Transaction_Amount) AS MinAmount,
    MAX(Transaction_Amount) AS MaxAmount,
    AVG(Transaction_Amount) AS AvgAmount,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Transaction_Amount) AS Q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Transaction_Amount) AS Median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Transaction_Amount) AS Q3
FROM FraudDB_Transactions;

-- 2️⃣ Count of transactions by state
SELECT Transaction_State, COUNT(*) AS TransactionCount
FROM FraudDB_Transactions
GROUP BY Transaction_State
ORDER BY TransactionCount DESC;

-- 3️⃣ Transactions by merchant category
SELECT Merchant_Category, COUNT(*) AS TransactionCount, SUM(Transaction_Amount) AS TotalAmount
FROM FraudDB_Transactions
GROUP BY Merchant_Category
ORDER BY TotalAmount DESC;

-- 4️⃣ High-value transactions (top 20)
SELECT TOP 20 * 
FROM FraudDB_Transactions
ORDER BY Transaction_Amount DESC;

-- 5️⃣ Transactions per customer (frequency analysis)
SELECT Customer_ID, COUNT(*) AS TransactionCount, SUM(Transaction_Amount) AS TotalSpent
FROM FraudDB_Transactions
GROUP BY Customer_ID
ORDER BY TransactionCount DESC;

-- 6️⃣ Customer income distribution
SELECT 
    MIN(Income) AS MinIncome,
    MAX(Income) AS MaxIncome,
    AVG(Income) AS AvgIncome,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Income) AS Q1,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Income) AS Median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Income) AS Q3
FROM Customer_Profile;

-- 7️⃣ Customer distribution by tenure (years)
SELECT Account_Tenure_Years, COUNT(*) AS CustomerCount
FROM Customer_Profile
GROUP BY Account_Tenure_Years
ORDER BY Account_Tenure_Years;

-- 8️⃣ Customers with multiple transactions in a single day (possible anomaly)
SELECT Customer_ID, CAST(Transaction_Timestamp AS DATE) AS TransactionDate, COUNT(*) AS DailyTxnCount
FROM FraudDB_Transactions
GROUP BY Customer_ID, CAST(Transaction_Timestamp AS DATE)
HAVING COUNT(*) > 3
ORDER BY DailyTxnCount DESC;

-- 9️⃣ Average transaction amount per customer
SELECT Customer_ID, AVG(Transaction_Amount) AS AvgTxnAmount
FROM FraudDB_Transactions
GROUP BY Customer_ID
ORDER BY AvgTxnAmount DESC;

-- 🔟 Cross-state transactions: transactions outside registered state
SELECT t.Customer_ID, t.Transaction_State, c.State AS Registered_State, COUNT(*) AS Count
FROM FraudDB_Transactions t
JOIN Customer_Profile c ON t.Customer_ID = c.Customer_ID
WHERE t.Transaction_State <> c.State
GROUP BY t.Customer_ID, t.Transaction_State, c.State
ORDER BY Count DESC;

-- 1️⃣1️⃣ Identify extreme spenders relative to income (txn/income ratio)
SELECT 
    t.Customer_ID,
    t.Transaction_ID,
    t.Transaction_Amount,
    c.Income,
    ROUND(t.Transaction_Amount / NULLIF(c.Income,0),3) AS Txn_to_Income_Ratio
FROM FraudDB_Transactions t
JOIN Customer_Profile c ON t.Customer_ID = c.Customer_ID
ORDER BY Txn_to_Income_Ratio DESC;
