# 🌐 Internet Usage and Political Polarization Analysis

A statistical analytics project investigating whether internet usage influences political polarization in the United States using four years of Pew Research Center survey data (2020–2023).

This project applies multiple statistical modeling techniques, data preparation, and exploratory data analysis to evaluate the relationship between internet use and political party favorability while controlling for demographic factors.

---

## 📖 Project Overview

Political polarization continues to shape public discourse in the United States, while internet usage has become the primary source of news and political information.

The objective of this project was to determine whether increased internet usage is associated with stronger political polarization and whether those effects vary across demographic groups.

Using more than **32,000 survey responses** collected over four years, this project applied statistical modeling techniques to evaluate these relationships and communicate findings through data visualization and reporting.

---

## 🎯 Research Questions

- Does more frequent internet use increase political polarization?
- Does the relationship between internet use and political affiliation vary by age?
- Does the relationship vary across racial groups?

---

## 📊 Dataset

**Source**

- Pew Research Center – American Trends Panel

**Years**

- 2020
- 2021
- 2022
- 2023

**Observations**

- Over 32,000 survey responses

**Variables Included**

- Internet usage frequency
- Republican favorability
- Democratic favorability
- Age
- Gender
- Race
- Education
- Income
- Political affiliation

---

## 🔄 Data Preparation

The data required extensive preprocessing before analysis.

Key preparation steps included:

- Cleaning missing and invalid responses
- Removing "Don't Know" and refused responses
- Standardizing variables across four survey years
- Rescaling favorability measures to a common scale
- Feature engineering age and income variables
- Encoding categorical variables
- Log transformation of income
- Preparing analysis-ready datasets in R

---

## 📈 Exploratory Data Analysis

Performed exploratory analysis using:

- Distribution analysis
- Correlation analysis
- Bar charts
- Box plots
- Trend comparisons
- Cross-year comparisons

Visualizations were developed to explore relationships between internet usage, political favorability, age, and race before statistical modeling.

---

## 🤖 Statistical Models

Multiple modeling approaches were evaluated and compared.

### Models Implemented

- Ordinal Logistic Regression
- Ordinary Least Squares (OLS)
- Poisson Generalized Linear Models (GLM)

### Variables Controlled

- Age
- Gender
- Race
- Education
- Income
- Political Party

### Interaction Effects

The models evaluated interaction effects between:

- Internet Usage × Age
- Internet Usage × Race

---

## ✔ Model Validation

Model assumptions were evaluated through:

- Dispersion testing
- Durbin-Watson tests
- Residual diagnostics
- Goodness-of-fit comparisons
- Cross-model validation

The Poisson GLM was selected as the most appropriate model based on the data characteristics.

---

## 📌 Key Findings

- No consistent evidence that frequent internet use increases political polarization.
- Internet usage did not demonstrate a significant interaction with age.
- The relationship between internet use and political favorability varied more substantially across racial groups.
- Effects were inconsistent across survey years, suggesting internet usage alone is not a reliable predictor of political polarization.

---

## 🛠 Technologies Used

### Programming

- R

### Libraries

- MASS
- dplyr
- rio
- stargazer
- PerformanceAnalytics
- lmtest
- car
- vtable

### Statistical Techniques

- Ordinal Logistic Regression
- Poisson Regression
- Linear Regression
- Feature Engineering
- Exploratory Data Analysis
- Statistical Diagnostics

---

## 💡 Skills Demonstrated

- Statistical Modeling
- Predictive Analytics
- Data Cleaning
- Feature Engineering
- Data Transformation
- Exploratory Data Analysis
- Model Selection
- Regression Analysis
- Data Visualization
- Research Methodology
- Statistical Diagnostics
- Technical Reporting

---

## 📈 Business Value

This project demonstrates the ability to transform large-scale survey data into meaningful analytical insights using statistical modeling and data-driven decision making.

The workflow mirrors real-world analytics projects by combining:

- Data preparation
- Statistical analysis
- Model evaluation
- Business interpretation
- Executive reporting

---

## 🚀 Future Improvements

Potential enhancements include:

- Longitudinal panel analysis using repeated respondents
- Machine Learning classification models
- Geographic (state-level) analysis
- Sentiment analysis of political media
- Time-series analysis
- Interactive dashboards in Tableau or Power BI

---

## 📷 Sample Outputs

*(Add screenshots here)*

Suggested screenshots:

- Distribution Charts
- Correlation Matrix
- Box Plots
- Regression Output
- Model Comparison Tables

---

## 👤 Author

**Safiya Joseph**

Master of Science – Artificial Intelligence & Business Analytics

**Core Skills**

- R
- SQL
- Python
- Statistical Modeling
- Business Intelligence
- Data Analytics
- Machine Learning
- Tableau
- Power BI
