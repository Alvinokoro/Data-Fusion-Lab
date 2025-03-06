This project involves the analysis of a healthcare dataset to derive insights regarding patient bills, medical conditions, demographic trends, and factors influencing healthcare costs. By performing data cleaning, statistical analysis, and data visualization, i aim to understand various aspects of healthcare data, such as billing trends, patient age, and hospital characteristics.

Project Goals
Analyze billing patterns across different medical conditions.
Investigate the correlation between patient age and healthcare costs.
Explore the distribution of blood types among different medical conditions.
Evaluate the length of patient stays in hospitals and its impact on costs.
Assess how admission types (Emergency, Elective, Urgent) influence billing and length of stay.
Gender-based distribution analysis across different medical conditions.
Impact of insurance providers on healthcare costs for similar medical conditions.

Key Steps in Analysis
1. Data Cleaning
Removed rows with missing values using the complete.cases() function.
Converted necessary columns to the appropriate data types, such as numeric for "Bill" and "Age".
Removed unnecessary columns, such as Room.Number, and converted categorical variables to factors.

2. Data Transformation
Created new columns like Length_of_Stay based on admission and discharge dates.
Grouped and summarized the data to calculate mean bills per medical condition, the correlation between age and bills, and the impact of admission types on the bill and length of stay.

3. Statistical Analysis
Performed T-tests and linear regression models to evaluate hypotheses, such as the relationship between age and healthcare costs and the impact of admission types on both billing and patient stay duration.

4. Data Visualization
Used ggplot2 and plotly to create visualizations like bar plots, box plots, and stacked bar charts. These plots help in visualizing correlations, distributions, and comparisons across different groups (e.g., medical conditions, gender, admission types).

Key Findings
1. Average Bill per Medical Condition
The analysis revealed the average healthcare bill for different medical conditions, with some conditions like Obesity and Diabetes having higher average costs than others.

2. Age vs. Bill Correlation
The analysis showed no significant difference in healthcare costs between older (50+) and younger patients. The p-value from the T-test was 0.832, suggesting no strong evidence of higher costs for older patients.

3. Blood Type Distribution
Blood type distribution varied across different medical conditions, with certain blood types being more prevalent in specific conditions. A stacked bar plot was used to visualize these distributions.

4. Length of Stay by Hospital
The analysis of patient stay durations across hospitals identified the hospitals with the highest average length of stay. This can be valuable in understanding hospital operational characteristics.

5. Admission Types and Their Impact
Admission type (Emergency, Elective, Urgent) had significant impacts on both billing amounts and length of stay. Patients with Emergency admissions had higher bills and longer stays, which was visualized using box plots.

5. Gender Distribution Across Medical Conditions
There were notable gender-based trends in the distribution of patients across medical conditions. These patterns were visualized using bar charts and helped uncover any disparities.

6. Insurance Providers' Impact on Billing
Insurance providers did influence billing amounts for patients with similar medical conditions, with some insurers covering more expensive treatments. The data was visualized through grouped bar charts for clarity.

Tools & Libraries Used
R for data cleaning, analysis, and visualization.
dplyr for data manipulation (e.g., grouping, summarizing).
ggplot2 for static visualizations (bar plots, box plots, etc.).
plotly for interactive visualizations (interactive bar charts, etc.).
Hmisc for data description and summarization.

How to Run the Code
1. Clone the repository to your local machine or use it in an R environment.
2. Install the necessary R packages:
install.packages(c("dplyr", "Hmisc", "ggplot2", "plotly"))
3. Load the dataset (update the file path if necessary):
healthcare_data <- read.csv('path/to/your/healthcare_dataset.csv')
4. Execute the analysis step by step by running the script.
