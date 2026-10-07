# UBA-Fraud-Detection-Analysis
Behavioral pattern and risk exposure analysis on a 200,000-row financial fraud detection dataset, built with SQL, Power BI, and Excel.
## Overview

This project analyzes transaction-level data from UBA (United Bank for Africa) to explore behavioral patterns tied to fraudulent activity and identify risk indicators that could support a fraud monitoring system. The dataset contains customer attributes, transaction characteristics, and device and location information, structured for binary classification (fraud vs. legitimate).

The work covers data quality review, privacy compliance, class imbalance assessment, risk exposure across account and transaction characteristics, temporal pattern analysis, device and channel risk profiling, geographic risk concentration, financial behavior analysis, an interactive monitoring dashboard, and a set of business recommendations.

## Dataset
Source: - <a href="https://docs.google.com/spreadsheets/d/1TqYGy-pIXw5V8xWQAcEO2iE8L0U6FP2P/edit?usp=drive_link&ouid=113197400564921458533&rtpof=true&sd=true">Dataset</a>

Raw size: 200,002 rows, 22 columns

Cleaned size: 200,000 rows, 19 columns

Time period: January 2025 (single month)

Target variable: is_fraud (0 = legitimate, 1 = fraud)

## Tools Used
SQL — data cleaning, transformation, and all exploratory analysis

Power BI — interactive dashboard and DAX measures

Excel — spot checks on small extracts

## Project Structure
```text
├── README.md
├── data/
│   └── UBA_Fraud_Cleaned.csv
├── sql/
│   ├── 01_data_quality_and_privacy.sql
│   └── 02_analysis_tasks_2to6.sql
├── dashboard/
│   └── Fraud_Detection_Dashboard.pbix
└── report/
    └── UBA_Fraud_Detection_Report.docx
```
## Data Quality Review and Privacy Compliance

The raw file had 2 fully blank rows across every column, removed to leave 200,000 complete rows. No partial nulls were found anywhere else, and no duplicate transaction_id values existed after the blank rows were dropped.

All categorical fields (gender, account type, transaction type, merchant category, device type) were already consistently labeled, with no spelling variants or case mismatches.

transaction_amount and account_balance were stored as text with a naira symbol and thousands separators and were cast to decimal. transaction_date and transaction_time were parsed into proper date and time types. All columns were renamed to lower_snake_case.

Three direct personal identifiers, customer_name, customer_contact, and customer_email, were removed entirely. customer_id was retained, since it is a system-generated identifier with no reversible link to a real name and still allows behavioral tracking without exposing anyone's identity.

Full SQL documentation: sql/01_data_quality_and_privacy.sql

## Key Findings
Class Distribution

Fraud accounts for 5.04% of transactions (10,088 of 200,000), legitimate transactions for 94.96%, a ratio of roughly 19 to 1. This imbalance means accuracy alone would be a misleading metric for any future model. A model predicting "not fraud" on every transaction would still score above 94% while catching zero fraud. Precision, recall, and F1 on the fraud class matter more than overall accuracy.

Risk by Account and Transaction Characteristics

Fraud rate holds in a tight 4.9% to 5.2% band across every account type (Business, Savings, Checking) and every transaction type. No category is meaningfully riskier than another.

Temporal Patterns

Data covers a single month. No day of week or hour of day shows a real spike. Daily fraud rate fluctuates around the 5.04% baseline throughout, with no sustained upward or downward trend.

## Device and Channel Risk
Channel |	Fraud Rate
:--- | :---
Debit/Credit Card |	5.50%
Virtual Card |	5.45%
Biometric Scanner |	5.39%
Payment Gateway Device |	5.36%
QR Code Scanner |	5.18%

Spread across all channels stays under half a point.

Geographic Concentration

Enugu is the highest state at 5.40%, Port Harcourt the lowest at 4.36%. At branch level (minimum 500 transactions), Atimbo (6.15%), Itam (6.14%), and Lafenwa (6.14%) run highest.

Financial Behavior

Transaction amount and account balance show almost no relationship to fraud, with fraud rate flat across every quintile of both. Every customer_id in the dataset appears exactly once, so frequency or velocity-based behavior analysis was not possible with this data structure.

## Operational Risk Monitoring Dashboard

An interactive four-page Power BI dashboard supports fraud operations and compliance review:

Overview — total transactions, fraud rate, transaction outcome split, daily fraud rate trend

Risk by Segment — fraud rate by account type, merchant category, and transaction device

Geographic Hotspots — fraud rate by state and top bank branches by fraud rate

Financial Behaviour — transaction amount vs. account balance, colored by fraud outcome

Each page includes Account_Type and Transaction_Type slicers, plus a Fraud Only toggle.

## Business Insights and Risk Mitigation Recommendations

### Key Insights

Fraud sits at 5.04% of all transactions, about 1 in 19.

No single feature strongly separates fraud from legitimate activity.

Card, virtual card, and biometric channels sit slightly above baseline.

Enugu state and three branches show the highest fraud concentration.

### Recommendations

Build detection rules on combined conditions, not single fields.

Flag high channels and branches for review, not automatic blocks.

Capture repeat transactions per customer to enable velocity checks.

Prioritize precision and recall over accuracy in future models.
