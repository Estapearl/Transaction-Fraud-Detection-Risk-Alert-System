<h1>Transaction Monitoring &amp; Fraud Risk Prioritization Using Behavioral and Rule-Based Signals</h1>
<p style="font-size: 0.95em; margin-top: 0.25rem;">
  <strong>Domain:</strong> Transaction Monitoring | Fraud Analytics | Digital Banking
</p>


<section id="risk-data-context">
  <h2>Risk &amp; Data Context</h2>

  <p>
    This project focuses on transaction monitoring for a digital payments company that supports everyday
    customer and business transactions. As transaction activity increased, so did the risk of unusual or
    potentially fraudulent behavior, making early risk detection an important priority.
  </p>

  <p>
    The analysis used two years of transaction data (2023–2024), covering around <strong>2,000 customers</strong>
    and <strong>50,000 transactions</strong>. This data made it possible to understand how customers normally
    transact and to spot activity that stood out from their usual patterns.
  </p>

  <p>
    The goal was not to confirm fraud, but to flag <strong>higher-risk activity</strong> that should be reviewed
    by a fraud or risk team. This mirrors how transaction monitoring works in practice, where clear and
    explainable signals help teams focus on the right cases without disrupting legitimate customers.
  </p>
</section>

<section id="fraud-risk-areas-analyzed">
  <h2>Fraud Risk Areas Analyzed</h2>
  <ul>
    <li><strong>Customer transaction behavior:</strong> Establishing normal spending patterns for each customer, including frequency, typical amounts, merchant types, and usual locations.</li>
    <li><strong>Unusual transaction activity:</strong> Identifying transactions that deviate from normal behavior, such as high-value spending, unexpected locations, or sudden bursts of activity.</li>
    <li><strong>Rule-based fraud risk scoring:</strong> Applying clear business rules to convert suspicious signals into a simple fraud score used to prioritize risk.</li>
    <li><strong>Fraud alerts for investigation:</strong> Consolidating transaction details, customer context, triggered rules, and risk levels into an alert view that supports faster review.</li>
  </ul>
</section>

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
  

<section id="finding-1">
  <h3>Finding 1: High-risk activity was concentrated within the first six months after account opening</h3>

  <p>
    A significant portion of the high-risk activity identified occurred within the first six months after
    account opening. These cases were driven by newly opened accounts making unusually large transactions
    early on, particularly amounts above <strong>$7,000</strong> or transactions exceeding
    <strong>15%</strong> of reported income.
  </p>

  <p>
    This pattern is commonly associated with account misuse or mule activity, where accounts are quickly used
    for high-value transactions shortly after being created. Monitoring for high spending during the early
    months of an account’s lifecycle helps surface this type of risk before activity escalates.
  </p>
</section>


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

**How alerts are generated**
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

📎 [View Fraud Alert Table structure and sample output](https://docs.google.com/spreadsheets/d/1uHo4rg9z4UjpPLAJCsCqkzsN-8kPJByV/edit?usp=sharing&ouid=116906689787133958270&rtpof=true&sd=true)


<h2>Recommendations</h2>

<ol>
  <li>
    <strong>Prioritize Investigation of High and Medium-Risk Customers</strong><br>
    Based on the fraud alert table, customers triggering <strong>2 or more rules</strong> are high risk, while those triggering <strong>1 rule</strong> are medium risk. Immediate investigation should focus on these groups, as even a single rule trigger may indicate fraudulent activity (observed in Rule 1: Cross-State transactions and Rule 2: New Account high spend).
  </li>
  
  <li>
    <strong>Monitor New Customers Closely</strong><br>
    Analysis showed that <strong>customers within their first 6 months</strong> are disproportionately flagged across rules, especially for large transactions relative to income (Rule 2 and Rule 3). Strengthen verification checks for new accounts and implement early warning alerts.
  </li>
  
  <li>
    <strong>Focus on Income-Relative High Transactions</strong><br>
    Transactions exceeding <strong>15% of reported income</strong> were consistently flagged, highlighting potential misuse (observed in Rule 2 and Rule 3). Consider adaptive transaction limits or manual review for accounts exhibiting this behavior.
  </li>
  
  <li>
    <strong>Leverage Behavioral Burst Analysis</strong><br>
    Customers making <strong>3+ transactions in a single day</strong> or unusually high same-day spending (Rule 3) are strong fraud indicators. Implement daily monitoring dashboards for abnormal activity spikes.
  </li>
  
  <li>
    <strong>Integrate Fraud Scoring into Operational Workflows</strong><br>
    Use the fraud score (1–3 points) to prioritize which alerts feed into the fraud monitoring dashboard. Customers with all three rules triggered are <strong>highest priority</strong>, ensuring investigators allocate attention effectively.
  </li>
  
  <li>
    <strong>Regularly Update Rules Based on Observed Patterns</strong><br>
    Patterns in the alert table indicate concentrated fraud signals among a <strong>small subset of customers</strong>. Periodic review of flagged transactions and rule thresholds will maintain detection accuracy and reduce false positives.
  </li>
</ol>











