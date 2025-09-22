# Data Analysis Using R Programming - Customer Churn

## Project Overview
This project performs a comprehensive **data analysis** on a customer churn dataset using **R Programming**. The analysis includes data cleaning, visualization, and exploratory data analysis (EDA) to uncover patterns and insights related to customer churn.

**Technologies & Packages Used:**
- R Programming
- ggplot2
- dplyr
- caret
- missForest

## Features
1. Data Cleaning:
   - Imputation of missing values using `missForest`
   - Conversion of numeric and categorical variables
2. Exploratory Data Analysis (EDA):
   - Gender distribution
   - Senior citizen analysis
   - Internet and phone service analysis
   - Payment method analysis
   - Total charges distribution
3. Visualizations:
   - Bar charts, pie charts, line plots
4. Outputs:
   - Cleaned dataset saved as `customerchurn_cleaned.csv`
   - All plots generated and saved in the project folder

## File Structure
-customer_churn1.csv
-customerchurn_cleaned.csv
-Mohantynaanee1.R
-README.md
-outputs/ (folder containing all generated graphs)


## How to Run
1. Open `Mohantynaanee1.R` in **RStudio**.
2. Install required packages if not already installed:
```R
install.packages(c("dplyr", "ggplot2", "caret", "missForest"))

