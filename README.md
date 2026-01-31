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
  
<h2>Key Findings from Transaction Monitoring</h2>
<p>
  After applying the transaction monitoring logic, several consistent risk patterns emerged across customer
  and transaction activity. These insights highlight where higher-risk behavior tended to concentrate and help
  explain how alerts can be prioritised for further review.
</p>


<section id="Insight-1">
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

<section id="key-findings-transaction-monitoring">
  <h2>Key Findings from Transaction Monitoring</h2>
</section>
<p>
  After applying the transaction monitoring logic, several consistent risk patterns emerged across customer
  and transaction activity. These insights highlight where higher-risk behavior tended to concentrate and help
  explain how alerts can be prioritised for further review.
</p>


<section id="insight-2">
  <h3>Insight 2: Early high-value out-of-state spending stood out, especially across certain merchant categories</h3>

  <p>
    A recurring risk pattern involved newly opened accounts making high-value transactions outside their
    registered state within the first six months after account opening. These cases stood out most when the
    spending occurred across merchant categories such as <strong>electronics</strong>, <strong>gambling</strong>,
    and <strong>home maintenance</strong>, particularly when transaction amounts exceeded <strong>$4,000</strong>
    or represented a large share of a customer’s reported income.
  </p>

  <p>
    Combining transaction value, location change, and merchant context helped highlight activity that was less
    consistent with routine customer behavior and more indicative of potential account misuse. This approach
    supports more focused reviews by prioritizing cases where multiple risk indicators align, rather than
    relying on a single signal alone.
  </p>
</section>

<section id="insight-3">
  <h3>Insight 3: Same-day transaction bursts were a clear risk pattern in new accounts</h3>

  <p>
    A noticeable pattern involved newer accounts showing unusually intense activity within a single day.
    This included customers making <strong>three or more transactions in one day</strong>, or making a
    <strong>very large transaction (above $6,000)</strong>, especially when the amount was high relative to
    their reported income.
  </p>

  <p>
    This kind of rapid, high-value activity can reflect attempts to move funds quickly rather than normal
    day-to-day spending. Highlighting these same-day bursts helps risk teams focus on cases where both speed
    and transaction size increase the potential risk.
  </p>
</section>

<section id="fraud-risk-scoring">
  <h2>Fraud Risk Scoring and Alert Prioritization</h2>

  <p>
    To move from identifying risk patterns to taking action, the transaction monitoring signals were combined
    into a simple fraud risk scoring approach. Rather than treating every flagged transaction the same, risk
    was prioritised based on how many independent risk indicators appeared together.
  </p>

  <p>
    Transactions that triggered <strong>one risk rule</strong> were classified as <strong>medium risk</strong>
    and flagged for review. Transactions that triggered <strong>two risk rules</strong> were classified as
    <strong>high risk</strong>, while transactions that triggered <strong>all three rules</strong> were
    classified as <strong>very high risk</strong> and represented the highest-priority cases for investigation.
  </p>

  <p>
    This scoring structure helped separate isolated risk signals from cases where multiple indicators aligned,
    allowing investigative attention to be focused where potential risk was greatest. It also provided clearer
    guidance to <strong>operations teams</strong> by indicating which cases required immediate attention versus
    those that could be handled through standard review processes.
  </p>

  <p>
    While all rules were initially treated with equal importance for clarity and explainability, the framework
    allows for future refinement. In a production environment, certain signals—such as spending far above
    reported income—could be prioritised further based on observed risk and business impact.
  </p>
</section>


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











