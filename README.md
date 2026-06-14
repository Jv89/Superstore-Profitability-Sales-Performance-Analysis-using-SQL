## Project Overview

This project analyzes the Superstore dataset using SQL to understand sales performance, profitability, discount behavior, customer contribution, and product-level loss drivers.

The goal is to move beyond basic SQL practice and treat the dataset as a business case study: identify where the business is performing well, where profit is being lost, and which areas should be reviewed for improvement.

## Business Objective

Identify the main drivers of sales and profit across regions, categories, customers, shipping methods, and discount levels in order to recommend actions that could improve profitability and operational visibility.

## Dataset

The dataset contains order-level retail sales information, including:

- Order details
- Customer information
- Product category and sub-category
- Region and shipping mode
- Sales, quantity, discount, and profit

Dataset size:

- 9,994 rows
- 5,009 unique orders
- 793 unique customers
- $2.30M total sales
- $286.40K total profit

## Tools Used

- SQL
- Superstore CSV dataset
- Relational database table named `superstore`

## Business Questions

This analysis focuses on the following questions:

1. What is the overall business performance in terms of sales, profit, orders, and customers?
2. Which regions generate the highest sales, profit, and profit margin?
3. Which product categories and sub-categories drive or reduce profitability?
4. Are discounts helping sales while reducing profit?
5. Which customers contribute the most to sales and profit?
6. Which products generate losses and should be reviewed?
7. How do shipping methods compare by order volume, quantity, and profitability?
8. How have sales and profit changed over time?
9. How can `CASE WHEN` statements be used to create business categories for analysis?

## Key SQL Skills Demonstrated

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- `HAVING`
- Aggregate functions: `SUM`, `COUNT`, `AVG`, `MIN`, `MAX`
- `COUNT(DISTINCT)`
- `CASE WHEN` statements
- Common Table Expressions, also known as CTEs
- Window functions: `RANK()` and `ROW_NUMBER()`
- Profit margin calculations
- Business segmentation logic

## Main Findings

### 1. Overall Performance

The dataset includes 5,009 unique orders from 793 customers, generating approximately $2.30M in total sales and $286.40K in total profit.

### 2. Regional Performance

The West region generated the highest total profit with approximately $108.42K, followed by the East region with approximately $91.52K. The Central region had the lowest profit margin at around 7.92%, which suggests it may require deeper review.

### 3. Category Performance

Technology generated the highest profit at approximately $145.45K, followed by Office Supplies at approximately $122.49K. Furniture generated high sales but only around $18.45K in profit, resulting in a much lower margin of approximately 2.49%.

### 4. Discount Impact

Orders with no discount generated the highest profit margin, around 29.51%. Medium and high discount orders showed negative profit margins, suggesting that aggressive discounting may be hurting profitability.

### 5. Loss Drivers

Tables, Bookcases, and Supplies were among the sub-categories with negative total profit. These areas should be reviewed for pricing, discounting, cost, or fulfillment issues.

## Recommendations

1. Review discount policies, especially for medium and high discount orders, because these groups show negative profitability.
2. Investigate the Furniture category, especially Tables and Bookcases, because sales volume does not translate into strong profit.
3. Analyze the Central region in more detail due to its lower profit margin compared with other regions.
4. Monitor products and customers that generate high sales but low or negative profit.
5. Create recurring monthly reporting for sales, profit, margin, and discount performance.

## Project Structure

```text
Superstore/
├── README.md
├── sql/
│   └── Superstore_Analysis.sql
└── data/
    └── Sample - Superstore.csv
```

## How to Use This Project

1. Import the CSV dataset into a SQL database.
2. Name the table `superstore`.
3. Run the queries in `Superstore_Analysis.sql`.
4. Review the outputs and compare them with the insights documented in this README.

## Next Steps

To make this project even stronger, the next version could include:

- A dashboard in Power BI, Tableau, or Excel
- Monthly trend visuals
- A Python notebook for data cleaning and visualization
- Additional analysis by customer segment and state
- A deeper investigation into discount strategy and loss-making products
