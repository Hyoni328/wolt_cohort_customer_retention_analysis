# Wolt Cohort & Customer Retention Analysis

This project contains my practice work based on the BI Developer internship assignment from Wolt. [analytics-summer-intern-2022](https://github.com/woltapp/analytics-summer-intern-2022). The original assignment involves analyzing customer retention based on when users made their first ever purchase using SQL and visualization tools.

## Original Data Explanation

The data consists of two CSV files:  
- `first_purchases.csv`
- `purchases.csv`

The dataset simulates a purchase process where a user makes their first and possibly subsequent purchases from Wolt. The first file contains only the users’ first purchases, and the second file contains all purchases from these users.

### Technical Assessment

Create visualizations showing the monthly customer retention per product line to communicate the following:
- Cohort-based monthly retention for **Retail** product line
- Cohort-based monthly retention for **Restaurant** product line

## My Approach

### Languages and Libraries Used
- Python (Pandas): Used for data cleaning before sending the cleaned data to MySQL
- MySQL
- Tableau

### Answer for the Additional Questions
- **Assumptions**:
  - The `first_purchases.csv` file correctly identifies the first purchase of each user.
  - The `purchases.csv` file contains all subsequent purchases after the first purchase.
- **Problems Encountered**:
  - The `purchases.csv` file did not include data from `first_purchases.csv`, requiring the creation of a temporary table to merge the datasets.
- **Additional Data Sources for Improvement**:
  - Customer demographics
  - Restaurant venue's categories
  - Marketing campaign data
  - Detailed transaction information, including discounts

### Visualization
![image](https://github.com/user-attachments/assets/12ea340f-812f-400d-bec9-b09b7a403be1)
Tableau public(https://public.tableau.com/app/profile/hyoeun.kim/viz/Tableau_cohort_customer_retention/Dashboard1?publish=yes)

## Conclusion

This project helped me practice SQL and data visualization skills. The insights gained from the analysis can help understand customer retention patterns and identify areas for improvement.
