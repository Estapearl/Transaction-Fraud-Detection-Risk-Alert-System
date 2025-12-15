/* =========================================================
   STAGE 1: DATA INSPECTION & CLEANING
   ---------------------------------------------------------
   Purpose:
   This stage ensures the transaction and customer datasets 
   are clean, accurate, and ready for fraud analysis. The 
   queries below:
     • Check table sizes
     • Detect duplicates
     • Identify missing/null values
     • Validate key fields
     • Remove or flag inconsistencies
   This is essential because clean data ensures accurate 
   fraud rule results and scoring.
========================================================= */

-- 1️⃣ Check total number of records in transactions and customer tables
SELECT COUNT(*) AS Total_Transactions FROM FraudDB_Transactions;
SELECT COUNT(*) AS Total_Customers FROM Customer_Profile;

-- 2️⃣ Preview the first 10 records to inspect data structure
SELECT TOP 10 * FROM FraudDB_Transactions;
SELECT TOP 10 * FROM Customer_Profile;

-- 3️⃣ Check for duplicate transactions (same customer, timestamp, and amount)
SELECT 
    Customer_ID, 
    Transaction_Timestamp, 
    Transaction_Amount,
    COUNT(*) AS DuplicateCount
FROM FraudDB_Transactions
GROUP BY Customer_ID, Transaction_Timestamp, Transaction_Amount
HAVING COUNT(*) > 1
ORDER BY DuplicateCount DESC;

-- 4️⃣ Identify duplicate customer records (same Customer_ID)
SELECT Customer_ID, COUNT(*) AS DuplicateCount
FROM Customer_Profile
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

-- 5️⃣ Check for missing critical fields in transactions
SELECT 
    SUM(CASE WHEN Transaction_ID IS NULL THEN 1 ELSE 0 END) AS MissingTransactionID,
    SUM(CASE WHEN Transaction_Amount IS NULL THEN 1 ELSE 0 END) AS MissingTransactionAmount,
    SUM(CASE WHEN Transaction_Timestamp IS NULL THEN 1 ELSE 0 END) AS MissingTransactionTimestamp,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID
FROM FraudDB_Transactions;

-- 6️⃣ Check for missing critical fields in customer profile
SELECT
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 ELSE 0 END) AS MissingCustomerID,
    SUM(CASE WHEN Income IS NULL THEN 1 ELSE 0 END) AS MissingIncome,
    SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS MissingState,
    SUM(CASE WHEN Join_Date IS NULL THEN 1 ELSE 0 END) AS MissingJoinDate,
    SUM(CASE WHEN Account_Tenure_Years IS NULL THEN 1 ELSE 0 END) AS MissingTenure
FROM Customer_Profile;

-- 7️⃣ Inspect negative or zero transaction amounts
SELECT * 
FROM FraudDB_Transactions
WHERE Transaction_Amount <= 0
ORDER BY Transaction_Amount;

-- 8️⃣ Inspect negative or zero customer income
SELECT * 
FROM Customer_Profile
WHERE Income <= 0
ORDER BY Income;

-- 9️⃣ Optional: Remove duplicate transactions (keeping the latest Transaction_ID)
-- Note: Keep this commented until confirmed
/*
DELETE t1
FROM FraudDB_Transactions t1
JOIN FraudDB_Transactions t2
  ON t1.Customer_ID = t2.Customer_ID
 AND t1.Transaction_Timestamp = t2.Transaction_Timestamp
 AND t1.Transaction_Amount = t2.Transaction_Amount
 AND t1.Transaction_ID < t2.Transaction_ID;
*/

-- 10️⃣ Optional: Remove duplicate customer records (keep the first occurrence)
-- Note: Keep this commented until confirmed
/*
DELETE c1
FROM Customer_Profile c1
JOIN Customer_Profile c2
  ON c1.Customer_ID = c2.Customer_ID
 AND c1.Join_Date < c2.Join_Date;
*/
