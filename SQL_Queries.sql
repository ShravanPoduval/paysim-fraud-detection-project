CREATE DATABASE paysim_db;

SHOW DATABASES;

USE PAYSIM_DB;
SHOW TABLES;
SELECT * FROM PAYSIM_cleaned;

ALTER TABLE PAYSIM_CLEANED ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;

ALTER TABLE paysim_cleaned
ADD COLUMN Transaction_Type VARCHAR(20);


-- Batch 1: 0 to 1,000,000
UPDATE paysim_cleaned
SET Transaction_Type = CASE
    WHEN Transaction_Type_CASH_OUT = 1 THEN 'CASH_OUT'
    WHEN Transaction_Type_DEBIT = 1 THEN 'DEBIT'
    WHEN Transaction_Type_PAYMENT = 1 THEN 'PAYMENT'
    WHEN Transaction_Type_TRANSFER = 1 THEN 'TRANSFER'
END
WHERE id BETWEEN 0 AND 1000000;

-- Batch 2: 1,000,001 to 2,000,000
UPDATE paysim_cleaned
SET Transaction_Type = CASE
    WHEN Transaction_Type_CASH_OUT = 1 THEN 'CASH_OUT'
    WHEN Transaction_Type_DEBIT = 1 THEN 'DEBIT'
    WHEN Transaction_Type_PAYMENT = 1 THEN 'PAYMENT'
    WHEN Transaction_Type_TRANSFER = 1 THEN 'TRANSFER'
END
WHERE id BETWEEN 1000001 AND 2000000;

-- Batch 3: 2,000,001 to 3,000,000
UPDATE paysim_cleaned
SET Transaction_Type = CASE
    WHEN Transaction_Type_CASH_OUT = 1 THEN 'CASH_OUT'
    WHEN Transaction_Type_DEBIT = 1 THEN 'DEBIT'
    WHEN Transaction_Type_PAYMENT = 1 THEN 'PAYMENT'
    WHEN Transaction_Type_TRANSFER = 1 THEN 'TRANSFER'
END
WHERE id BETWEEN 2000001 AND 3000000;

-- Batch 4: 4,000,001 to 5,000,000
UPDATE paysim_cleaned
SET Transaction_Type = CASE
    WHEN Transaction_Type_CASH_OUT = 1 THEN 'CASH_OUT'
    WHEN Transaction_Type_DEBIT = 1 THEN 'DEBIT'
    WHEN Transaction_Type_PAYMENT = 1 THEN 'PAYMENT'
    WHEN Transaction_Type_TRANSFER = 1 THEN 'TRANSFER'
END
WHERE id BETWEEN 4000001 AND 5000000;


-- Batch 5: 5,000,001 to 6,362,620
UPDATE paysim_cleaned
SET Transaction_Type = CASE
    WHEN Transaction_Type_CASH_OUT = 1 THEN 'CASH_OUT'
    WHEN Transaction_Type_DEBIT = 1 THEN 'DEBIT'
    WHEN Transaction_Type_PAYMENT = 1 THEN 'PAYMENT'
    WHEN Transaction_Type_TRANSFER = 1 THEN 'TRANSFER'
END
WHERE id BETWEEN 5000001 AND 6362620;

ALTER TABLE paysim_cleaned DROP COLUMN Transaction_Type_CASH_OUT;
ALTER TABLE paysim_cleaned DROP COLUMN Transaction_Type_DEBIT;
ALTER TABLE paysim_cleaned DROP COLUMN Transaction_Type_PAYMENT;
ALTER TABLE paysim_cleaned DROP COLUMN Transaction_Type_TRANSFER;

# 1. What is the total number of transactions in the dataset?
SELECT COUNT(*) AS Total_Transactions FROM paysim_cleaned;

# 2. What is the total number of fraudulent transactions?
SELECT COUNT(*) AS Fraud_Transactions FROM paysim_cleaned WHERE Is_Fraud = 1;

# 3. What percentage of transactions are fraudulent?
SELECT (SUM(Is_Fraud) / COUNT(*)) * 100 AS Fraud_Percentage FROM paysim_cleaned;

------------------------------------------------------------------------
SELECT COUNT(*) FROM paysim_cleaned WHERE Transaction_Type IS NULL;

UPDATE paysim_cleaned
SET Transaction_Type = 'UNKNOWN'
WHERE Transaction_Type IS NULL
LIMIT 1000000;
--------------------------------------------------------------------

# 4. What is the transaction count by transaction type?
SELECT Transaction_Type, COUNT(*) AS Total FROM paysim_cleaned GROUP BY Transaction_Type ORDER BY Total DESC;

# 5. Which transaction type has the highest fraud rate?
SELECT Transaction_Type,SUM(Is_Fraud) AS Fraud_Count,(SUM(Is_Fraud) / COUNT(*)) * 100 AS Fraud_Rate_Percent FROM paysim_cleaned GROUP BY Transaction_Type ORDER BY Fraud_Rate_Percent DESC;

# 6. What is the average transaction amount for fraudulent vs non-fraudulent transactions?
SELECT Is_Fraud,AVG(Amount) AS Average_Amount FROM paysim_cleaned GROUP BY Is_Fraud;

# 7. How many high amount transactions are fraudulent?
SELECT Is_High_Amount, COUNT(*) AS Total, SUM(Is_Fraud) AS Fraud_Count FROM paysim_cleaned GROUP BY Is_High_Amount;


# 8. Which transaction type and high amount combinations have the highest fraud rates?
SELECT Transaction_Type, Is_High_Amount, COUNT(*) AS Total_Transactions, SUM(Is_Fraud) AS Fraud_Count, ROUND(SUM(Is_Fraud)/COUNT(*)*100,2) AS Fraud_Percentage FROM paysim_cleaned GROUP BY Transaction_Type, Is_High_Amount ORDER BY Fraud_Percentage DESC LIMIT 50;

# 9. What are the average sender and receiver balance changes for fraudulent vs non-fraudulent transactions?
SELECT Is_Fraud, ROUND(AVG(Sender_Balance_Change),2) AS Avg_Sender_Change, ROUND(AVG(Receiver_Balance_Change),2) AS Avg_Receiver_Change FROM paysim_cleaned GROUP BY Is_Fraud;

# 10. How does the fraud rate vary across simulation steps (Step)?
SELECT Step,COUNT(*) AS Total_Transactions,SUM(Is_Fraud) AS Fraud_Count,ROUND(SUM(Is_Fraud)/COUNT(*)*100,2) AS Fraud_Percentage FROM paysim_cleaned GROUP BY Step ORDER BY Fraud_Percentage DESC LIMIT 20;








