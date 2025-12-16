<!-- Transaction Fraud Detection & Risk Alert System - Client Background -->
<section id="client-background">
  <h1>Transaction Fraud Detection &amp; Risk Alert System</h1>
  <p><strong>Domain:</strong> Fraud Analytics | Financial Crime | Digital Banking</p>


<h2>Company Background</h2>


FinTech Solutions Inc. is a financial technology company that provides digital payment and transaction services to both individual customers and businesses. 
As the company expanded its digital offerings, transaction volumes increased steadily, which also raised exposure to fraudulent activity and the need for 
stronger, more proactive fraud monitoring processes.
</p>

<p>
This analysis was conducted using two years of historical data (2023–2024), covering approximately <strong>2,000 customers</strong> and 
<strong>49,924 transactions</strong>. The dataset consisted of two primary tables: a <strong>Customer Profile table</strong>, which contained customer 
and account-level information, and a <strong>Transaction table</strong>, which captured detailed transaction activity across merchant categories, 
locations, and time periods.
</p>

<p>
From a fraud data analyst’s perspective, this dataset made it possible to understand how customers typically transact over time, identify meaningful 
changes in behavior, and flag transactions that deviated from expected patterns. The objective was not to label transactions as confirmed fraud, 
but to proactively highlight high-risk activity that required further review. This approach supports faster investigations, reduces potential customer 
impact, and strengthens the organization’s overall fraud monitoring capability.
</p>

## Key Analytical Focus Areas
<p>
<strong>Customer Behavior Profiling:</strong> Customer transaction histories were analyzed to establish what “normal” behavior looks like for each account. 
This included transaction frequency, typical spending ranges, preferred merchant categories, and usual transaction locations. Building this behavioral 
context made it easier to identify customers whose activity suddenly deviated from historical patterns, which is often an early indicator of potential 
fraud or account misuse.
</p>

<p>
<strong>Transaction Anomaly Detection:</strong> Transactions were reviewed for patterns commonly associated with elevated fraud risk, such as unusually 
large transaction amounts, cross-state activity that differed from a customer’s registered location, and abnormal transaction timing. These anomalies 
helped surface transactions that stood out from expected behavior and required closer attention from the fraud or compliance team.
</p>

<p>
<strong>Rule-Based Fraud Scoring:</strong> Business-driven fraud rules were applied to convert suspicious behavior into measurable risk signals. 
Each transaction was evaluated against predefined conditions, and a fraud score was assigned based on the number of risk indicators triggered. 
This scoring approach enabled consistent classification of transactions into Medium- and High-Risk categories, allowing investigative efforts 
to be prioritized more effectively.
</p>

<p>
<strong>Fraud Alert and Investigative Support:</strong> The final output of the analysis was a structured fraud alert table that consolidated transaction 
details, customer context, rule hits, and assigned risk levels into a single view. This structure supports faster case review, clearer prioritization 
of high-risk alerts, and smoother hand-off to investigation or compliance teams, aligning closely with real-world fraud monitoring workflows.
</p>

</div>

####  SQL Queries for Portfolio Analysis

- **Data Cleaning & Inspection** – [View Queries](./Data_Cleaning.sql)  
  Queries used to inspect, validate, and clean the dataset before analysis.

- **Exploratory Data Analysis (EDA)** – [View Queries](./EDA.sql)  
  Queries answering key business questions and exploring patterns in the data.

- **Feature Engineering** – [View Queries](./Feature_Engineering.sql)  
  Queries transforming raw data into meaningful features for analysis.

- **Rule-Based Fraud Detection** – [View Queries](./Rule_Based_Fraud_Detection.sql)  
  SQL logic for identifying suspicious customer and transaction behavior.

- **Fraud Scoring & Risk Classification** – [View Queries](./Fraud_Scoring_Model.sql)  
  Queries to calculate fraud scores and assign risk levels for flagged transactions.
  

## Insights Deep Dive Analysis
  
### a. Customer Risk Behavior Patterns

What we observed

Customer transaction histories were analyzed across a two-year period to understand how spending behavior differs between normal and high-risk accounts.

Several clear risk patterns emerged:
- Newer customers (first 6 months) were significantly more likely to trigger fraud rules compared to long-tenured customers.

- Customers whose transaction amounts exceeded **15%** of their reported income showed a much higher likelihood of being flagged.

- Fraud signals were concentrated among a small subset of customers, rather than evenly spread across the customer base

**Why this matters:**
These patterns help fraud teams focus monitoring efforts on high-risk customer segments early in the customer lifecycle, reducing false positives while improving early fraud detection.

### b. Transaction Anomaly Detection

What we observed

Transaction-level activity was reviewed across channels, locations, and time to identify behaviors that deviated from a customer’s usual pattern.

Key anomaly signals stood out:

- High-value transactions occurring outside a customer’s registered state were more likely to be flagged, especially for newer accounts.

- Sudden spikes in transaction activity within a single day (multiple transactions or unusually large amounts) indicated potential account takeover or misuse.

- Large transfers made shortly after account creation or following periods of low activity showed elevated fraud risk.

Why this matters

By focusing on deviations from normal transaction behavior rather than volume alone, fraud alerts become more targeted, allowing investigators to prioritize genuinely suspicious activity while reducing noise from legitimate transactions.

### c. Rule-Based Fraud Scoring

What we observed

Fraud risk was evaluated by applying multiple rule-based checks to each transaction and customer activity, rather than relying on a single indicator.
Key observations from the scoring logic:

- Transactions that triggered multiple fraud rules simultaneously were significantly more likely to represent genuine risk than those triggering only one rule.

- Cross-state high-value spending combined with new account activity consistently produced the highest fraud scores.

- Behavioral burst activity (multiple transactions in a short time window) often acted as a secondary risk amplifier, pushing cases from medium to high risk.

**Why this matters**

Scoring fraud using layered rules allows risk teams to prioritize investigations efficiently. Instead of treating all alerts equally, resources can be focused on high-scoring cases where multiple independent risk signals align, improving both detection accuracy and operational efficiency.

### d. Fraud Alert & Monitoring Readiness
What was built

To move the analysis closer to real-world application, fraud insights were translated into an actionable fraud alert system designed to support ongoing transaction monitoring and investigation.

Each transaction or customer activity is evaluated using a rule-based fraud scoring framework, where different fraud signals are combined into a single alert view. This ensures that potential risk is assessed holistically, rather than relying on isolated indicators.

How alerts are generated

Fraud alerts are generated by applying three core fraud detection rules:

- Cross-state high-value transactions
- High spending by newly opened accounts
- Unusual burst activity within short timeframes

Each triggered rule contributes one point to a fraud score whil the absence of any rule trigger indicates normal activity.

Risk classification is defined as follows:
- No Risk (Score = 0) → No rules triggered, normal activity
- Medium Risk (Score = 1) → One fraud rule triggered, requires review, as a single signal can still indicate fraud.
- High Risk (Score ≥ 2) → Multiple fraud rules triggered, strong evidence of suspicious behavior.
- Very High Risk (Score = 3) → All three fraud rules triggered. Indicates highly abnormal activity and requires immediate investigation.

This approach reflects real-world fraud monitoring, where a single strong signal can already indicate fraud, while multiple signals significantly increase confidence and urgency.

**Fraud Alert Output**
The final fraud alert table consolidates flagged transactions and customers across all fraud rules, including fraud score, risk level, and rule explanations. This table represents the operational output that would feed a fraud monitoring dashboard or investigation queue.

📎 View Fraud Alert Table structure and sample output










