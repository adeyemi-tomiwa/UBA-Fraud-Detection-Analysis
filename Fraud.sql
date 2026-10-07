--Load raw data into a stagitable
CREATE TABLE fraud(
    customer_id            TEXT,
    gender                 TEXT,
    age                    TEXT,
    state                  TEXT,
    city                   TEXT,
    bank_branch            TEXT,
    account_Type           TEXT,
    transaction_id         TEXT,
    transaction_date       TEXT,
    transaction_time       TEXT,
    transaction_amount     TEXT,
    merchant_id            TEXT,
    transaction_type       TEXT,
    merchant_category      TEXT,
    account_balance        TEXT,
    transaction_device     TEXT,
    transaction_location   TEXT,
    device_type            TEXT,
    is_Fraud               TEXT
);

ALTER TABLE fraud
DROP COLUMN customer_email;

SELECT*
FROM fraud

-- Count nulls per column
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) - COUNT(customer_id)        AS null_customer_id,
    COUNT(*) - COUNT(transaction_id)     AS null_transaction_id,
    COUNT(*) - COUNT(transaction_amount) AS null_transaction_amount,
    COUNT(*) - COUNT(is_fraud)           AS null_is_fraud
FROM fraud;

--Consistency check on categorical fields
SELECT DISTINCT "gender" FROM fraud;
SELECT DISTINCT "account_type" FROM fraud;
SELECT DISTINCT "transaction_type" FROM fraud;
SELECT DISTINCT "merchant_category" FROM fraud;
SELECT DISTINCT "device_type" FROM fraud;
SELECT DISTINCT "is_fraud" FROM fraud;


--Check for percentage of Fraudulent and Non-Fraud 
SELECT
    is_fraud,
    COUNT(*) AS txn_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM fraud), 2) AS pct
FROM fraud
GROUP BY is_fraud;

--Transaction Type by Fraud Rate 
SELECT account_type, COUNT(*) AS txn_count, SUM(is_fraud) AS fraud_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY account_type
ORDER BY fraud_rate_pct DESC;

--Transaction Type by Fraud Rate
SELECT transaction_type, COUNT(*) AS txn_count, SUM(is_fraud) AS fraud_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY transaction_type
ORDER BY fraud_rate_pct DESC;

-- TASK 4: TEMPORAL PATTERNS IN TRANSACTION AND FRAUD ACTIVITY
--Transaction Date by Fraud Rate
SELECT transaction_date, COUNT(*) AS txn_count, SUM(is_fraud) AS fraud_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY transaction_date
ORDER BY transaction_date;

--Transaction Date by Fraud Rate
SELECT 
    EXTRACT(DOW FROM transaction_date::date) AS day_of_week, 
    COUNT(*) AS txn_count,
    ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY day_of_week
ORDER BY day_of_week;

--Transaction time by Fraud Rate 
SELECT EXTRACT(HOUR FROM transaction_time::time) AS hour_of_day, COUNT(*) AS txn_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY hour_of_day
ORDER BY fraud_rate_pct DESC;

-- TASK 5: DEVICE AND CHANNEL RISK PROFILING
SELECT device_type, COUNT(*) AS txn_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY device_type
ORDER BY fraud_rate_pct DESC;

--Transaction Device by Fraud Rate
SELECT transaction_device, COUNT(*) AS txn_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY transaction_device
ORDER BY fraud_rate_pct DESC;

--Marchant Category by Fraud Rate
SELECT merchant_category, COUNT(*) AS txn_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY merchant_category
ORDER BY fraud_rate_pct DESC;

--TASK 6: GEOGRAPHICAL RISK CONCENTRATION ANALYSIS
SELECT state, COUNT(*) AS txn_count, SUM(is_fraud) AS fraud_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY state
ORDER BY fraud_rate_pct DESC;

--Bank Branch by Fraud Rate
SELECT bank_branch, COUNT(*) AS txn_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM fraud
GROUP BY bank_branch
HAVING COUNT(*) >= 500
ORDER BY fraud_rate_pct DESC
LIMIT 5;

-- TASK 7: FINANCIAL BEHAVIOR AND FRAUD LIKELIHOOD
SELECT is_fraud, ROUND(AVG(transaction_amount::numeric), 2) AS avg_amount,
       ROUND(AVG(account_balance::numeric), 2) AS avg_balance
FROM fraud
GROUP BY is_fraud;
-- Fraud rate by transaction amount quintile
WITH ranked AS (
    SELECT *, NTILE(5) OVER (ORDER BY transaction_amount) AS amt_quintile
    FROM fraud
)
SELECT amt_quintile, COUNT(*) AS txn_count,
       ROUND(AVG(is_fraud) * 100, 2) AS fraud_rate_pct
FROM ranked
GROUP BY amt_quintile
ORDER BY amt_quintile

SELECT current_database();

ALTER DATABASE "Fraud Detection" RENAME TO "Fraud DB";