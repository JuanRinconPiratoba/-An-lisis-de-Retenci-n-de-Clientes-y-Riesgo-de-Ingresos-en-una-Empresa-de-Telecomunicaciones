# Customer Churn Analytics

## Overview

This project analyzes customer churn behavior in a telecommunications company using the IBM Telco Customer Churn dataset.

The objective is to identify the main drivers of customer attrition, quantify revenue at risk, segment customers according to churn risk, and provide actionable business insights through an interactive Power BI dashboard.

## Business Problem

Customer churn directly impacts revenue, profitability, and customer lifetime value. Organizations need to understand which customers are more likely to leave and what factors influence retention in order to design effective retention strategies.

## Tools & Technologies

* PostgreSQL
* SQL
* Power BI
* DAX
* Excel

## Project Workflow

1. Data Quality Assessment
2. Data Cleaning & Transformation
3. PostgreSQL Data Modeling
4. Exploratory Data Analysis (SQL)
5. KPI Development
6. Customer Risk Segmentation
7. Power BI Dashboard Development
8. Business Recommendations

## Key Findings

* Overall Churn Rate: **26.54%**
* Lost Customers: **1,869**
* Revenue at Risk: **$139,130.85**
* Customers with month-to-month contracts showed the highest churn rates.
* Electronic Check users were significantly more likely to churn.
* Customers without Online Security and Tech Support presented elevated churn risk.
* The Critical Risk segment concentrated most of the revenue exposure.

## Dashboard Pages

### Executive Overview

Business KPIs, churn metrics, and revenue exposure.

### Customer Profile & Churn Drivers

Demographic and behavioral drivers of churn.

### Revenue & Customer Lifecycle Analysis

Customer tenure, contract analysis, and revenue insights.

### Customer Risk Segmentation

Risk classification, revenue at risk, and strategic recommendations.

## Repository Structure

```text
Customer-Churn-Analytics/
│
├── data/
├── sql/
├── powerbi/
├── dashboard_screenshots/
├── report/
├── README.md
│
└── Customer_Churn_Analytics.pbix
```

## Business Value

This project demonstrates how Customer Analytics and Business Intelligence can be used to identify churn drivers, prioritize retention efforts, and support data-driven decision making.

## Dataset

IBM Telco Customer Churn Dataset:
https://www.kaggle.com/datasets/blastchar/telco-customer-churn
