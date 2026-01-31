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

<section id="fraud-detection-rules-overview">
  <h2>Fraud Detection Rules Overview</h2>

  <p>
    The transaction monitoring framework was built using a small set of explainable, rule-based checks designed
    to highlight potentially high-risk activity early. These rules were intentionally simple and transparent,
    allowing risk signals to be clearly understood and reviewed.
  </p>

  <p>The core rules focused on three main risk areas:</p>

  <ul>
    <li>
      <strong>New account high spending:</strong> Identifying newly opened accounts making unusually large
      transactions, either in absolute terms or relative to reported income.
    </li>
    <li>
      <strong>Cross-state high-value spending:</strong> Highlighting high-value transactions occurring outside
      a customer’s registered state, particularly during the early months after account opening.
    </li>
    <li>
      <strong>Same-day behavioral bursts:</strong> Detecting multiple transactions or unusually large spending
      occurring within a single day, which may indicate rapid fund movement.
    </li>
  </ul>

  <p>
    Thresholds were calibrated to ensure the rules surfaced meaningful activity without generating excessive
    noise. Rather than acting as standalone fraud decisions, these rules were used together as part of a broader
    scoring and prioritisation framework.
  </p>
</section>


<section id="fraud-alert-output">
  <h2>Fraud Alert Output and Monitoring Readiness</h2>

  <p>
    The final output of this analysis was a structured fraud alert table designed to support day-to-day
    transaction monitoring. It consolidates key transaction details, customer context, triggered rules, fraud
    score, and assigned risk level into a single view.
  </p>

  <p>
    This alert format makes reviews faster and more consistent by allowing investigators to quickly understand
    what triggered the alert and how urgent the case is. It also supports prioritisation by separating medium,
    high, and very high risk activity, making it easier to manage an investigation queue or monitoring dashboard.
  </p>

  <p>
    In a real-world setup, this alert table could feed directly into a fraud monitoring dashboard or case
    management workflow, where higher-risk alerts are reviewed first and supporting transaction details are
    available for follow-up.
  </p>
</section>

<section id="recommendations">
  <h2>Recommendations</h2>

  <p>
    Based on the observed risk patterns and scoring approach, several practical recommendations emerge for
    improving transaction monitoring and investigation efficiency.
  </p>

  <ol>
    <li>
      <strong>Prioritise review of high and very high risk activity:</strong>
      Transactions triggering multiple risk indicators should be reviewed first, as they represent the strongest
      concentration of unusual behaviour and potential exposure.
    </li>
    <li>
      <strong>Apply closer monitoring during the early account lifecycle:</strong>
      Higher-risk activity was most commonly observed within the first six months after account opening.
      Strengthening monitoring during this period can help surface potential issues earlier and reduce downstream risk.
    </li>
    <li>
      <strong>Pay closer attention to high-value and income-disproportionate transactions:</strong>
      Transactions that are unusually large in absolute terms or high relative to reported income consistently appeared
      across higher-risk alerts and should remain a key focus area.
    </li>
    <li>
      <strong>Monitor same-day transaction bursts as an escalation signal:</strong>
      Rapid, high-value spending within a single day can indicate attempts to move funds quickly. These patterns are
      most effective when used alongside other indicators rather than in isolation.
    </li>
    <li>
      <strong>Review and refine rules regularly:</strong>
      Risk patterns were concentrated among a relatively small subset of customers. Periodic review of thresholds and
      rule performance can help ensure effectiveness while reducing unnecessary alerts.
    </li>
  </ol>
</section>

## SQL & Technical Appendix

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

📎 **Fraud Alert Output:**  
[View fraud alert table structure and sample output](https://docs.google.com/spreadsheets/d/1uHo4rg9z4UjpPLAJCsCqkzsN-8kPJByV/edit?usp=sharing&ouid=116906689787133958270&rtpof=true&sd=true)













