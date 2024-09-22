# 📦Shipment Orders Data Analysis
### Overview
This project focuses on analyzing shipment order data using Python, Pandas, and SQL. The aim is to derive insights related to sales performance, profit margins, and product trends. 📊
Table of Contents
-Installation
-Usage
-Data Description
-Key Features
-Data Analysis

# Installation 🛠️
To run this project, ensure you have the following libraries installed:

-pip install kaggle pandas sqlalchemy pymysql mysql-connector-python
-Setting Up Kaggle API
-Create a Kaggle account and download your kaggle.json API key. 🗝️
-Place the kaggle.json file in the ~/.kaggle/ directory
# Usage 🚀
-Clone this repository:
git clone https://github.com/yourusername/your-repo-name.git
cd your-repo-name
-Run the Jupyter Notebook to execute the data analysis.

# Data Description 📄
The dataset used in this project is the Shipment Orders Dataset, which contains various attributes related to shipment orders including:
-Order Date: Date of the order 📅
-Ship Mode: Mode of shipment 🚚
-Product Id: Unique identifier for products 🏷️
-Quantity: Number of units ordered 📦
-Cost Price: Cost of products 💰
-List Price: Listed price before discounts 💵
-Discount Percent: Discount applied 🔖
# Key Features ⭐
-Data cleaning and preprocessing.
-Calculation of selling prices and profit margins.
-Grouping and aggregating data for insightful metrics.
-SQL database integration for data storage and retrieval.
-Comprehensive queries to extract meaningful information.
# Data Analysis 📈
### Sample Queries
-Top 10 Highest Profit Generating Products 🏆
-Distinct Cities Where Orders Have Been Shipped 🌍
-Average Order Value 💹
-Total Sale in Each Region 🌎
# Code Snippets 💻
Here are some snippets from the analysis:
## Calculating Selling Price
df['Selling_Price'] = df['List Price'] - df['List Price'] * (df['Discount Percent'] / 100)

## Grouping by Product Id to find Total Profit
top_products = df.groupby('Product Id').sum('Total Profit').sort_values(by='Total Profit
