# Set working directory and read the dataset
setwd('C:\\Users\\ALVIN OKORO-IJAGHA\\Downloads\\healthcare_dataset.csv')
getwd()


healthcare_data <- read.csv('healthcare_dataset.csv')

# Load necessary libraries
library(dplyr)
library(Hmisc)
library(ggplot2)
library(plotly)

describe(healthcare_data)

# Check for missing values
total_missing_values <- sum(is.na(healthcare_data))  # Total missing values
missing_values_per_column <- colSums(is.na(healthcare_data))  # Missing values per column
total_missing_values
missing_values_per_column
# Handle missing values (e.g., remove rows with missing values or impute)
healthcare_data <- healthcare_data[complete.cases(healthcare_data), ]  # Remove rows with missing values

# Convert column data types if necessary
# Assuming the column names in the CSV file match the ones described earlier
healthcare_data$Bill <- as.numeric(healthcare_data$Bill)
healthcare_data$Age <- as.numeric(healthcare_data$Age)

# Remove unnecessary columns
healthcare_data <- healthcare_data %>%
  select(-Room.Number)  # Remove the "Room Number" column

# Convert categorical variables to factors
healthcare_data$Gender <- factor(healthcare_data$Gender)
healthcare_data$Medical.Condition <- factor(healthcare_data$Medical.Condition)

# Convert other categorical variables to factors as needed
healthcare_data$Blood.Type <- factor(healthcare_data$Blood.Type)
healthcare_data$Doctor <- factor(healthcare_data$Doctor)
healthcare_data$Hospital <- factor(healthcare_data$Hospital)
healthcare_data$Insurance.Provider <- factor(healthcare_data$Insurance.Provider)
healthcare_data$Admission.Type <- factor(healthcare_data$Admission.Type)
healthcare_data$Medication <- factor(healthcare_data$Medication)
healthcare_data$Test.Results <- factor(healthcare_data$Test.Results)

# # Remove duplicates (if any)
# healthcare_data <- View(distinct(healthcare_data)) error or so

# Display the cleaned data
print(healthcare_data)


# 1 What is the average bill per medical condition?
distinct_count<- length(unique(healthcare_data$Medical.Condition))
distinct_count
# Ob<-subset(healthcare_data,Medical.Condition=="Obesity")
# Ht<-subset(healthcare_data,Medical.Condition=="Hypertension")
# At<-subset(healthcare_data,Medical.Condition=="Arthritis")
# Db<-subset(healthcare_data,Medical.Condition=="Diabetes")
# Can<-subset(healthcare_data,Medical.Condition=="Cancer")
# As<-subset(healthcare_data,Medical.Condition=="Asthma")
# mean_obseity<-mean(Ob$Bill,na.rm=TRUE)
# mean_Hypertension<-mean(Ht$Bill,na.rm=TRUE)
# mean_Athritis<-mean(At$Bill,na.rm=TRUE)
# mean_Diabetes<-mean(Db$Bill,na.rm=TRUE)
# mean_cancer<-mean(Can$Bill,na.rm=TRUE)
# mean_Asthma<-mean(As$Bill,na.rm=TRUE)

mean_bill<-healthcare_data %>% group_by(Medical.Condition)%>%summarise(mean_bill=mean(Bill,na.rm=T))
View(mean_bill)

ggplot(mean_bill, aes(x = Medical.Condition, y = mean_bill, fill = Medical.Condition)) +
  geom_bar(stat = "identity") +
  labs(title = "Average Billing Amount by Medical Condition",
       x = "Medical Condition",
       y = "Average Billing Amount") 

# 2 Is there any correlation between patient age and bill
# Investigate whether older patients tend to incur higher healthcare costs compared to younger patients

lm_result<-lm(Bill~Age,healthcare_data)
lm_result
summary(lm_result)

# H0: older patients tend to incur higher healthcare costs compared to younger patients
# H1: older patients tend to not incur higher healthcare costs compared to younger patients

older<-subset(healthcare_data,Age>50)
younger<-subset(healthcare_data,Age<=50)

mean(older$Bill,na.rm = T)
mean(younger$Bill,na.rm=T)

t.test(older$Bill,younger$Bill,conf.level = 0.99)

#The p-value of 0.832 is relatively high,suggesting that there is insufficient evidence to reject nulll hyphothesis.
#We accept null hypothesis and conclude that there is no significant difference in mean healthcare costs between older and younger patients


# 3 What is the distribution of blood types among patients with different medical conditions?
# Explore if certain blood types are more prevalent among patients with specific medical conditions.
blood_type_distribution <- healthcare_data %>%group_by(Medical.Condition, Blood.Type) %>%summarise(count=n())
 #n: The number of observations in the current group


View(blood_group_distribution)

# Create the stacked bar plot
i<-ggplot(blood_type_distribution, aes(x = Medical.Condition, y = count, fill = Blood.Type))
p<-i+geom_bar(stat = "identity") +
  labs(title = "Distribution of Blood Types Among Different Medical Conditions",
       x = "Medical Condition",
       y = "Count of Patients",
       fill = "Blood Type") 
library(plotly) # It makes the ggplot interactive i.e see detailed info,zoom etc
p_interactive<- ggplotly(p)
p_interactive


# 4 Which hospitals have the highest average patient stay duration?

summary(healthcare_data)
str(healthcare_data)


healthcare_data$Date.of.Admission <- as.Date(healthcare_data$Date.of.Admission, format = "%m/%d/%Y")
healthcare_data$Discharge.Date <- as.Date(healthcare_data$Discharge.Date, format = "%m/%d/%Y")

sum(is.na(healthcare_data$Date.of.Admission))
sum(is.na(healthcare_data$Discharge.Date))

healthcare_data$Length_of_Stay <- as.numeric(healthcare_data$Discharge.Date - healthcare_data$Date.of.Admission, units = "days")
View(healthcare_data)

# Group by hospital and calculate average length of stay

avg_los<- healthcare_data %>% group_by(Hospital) %>% summarise(avgl=mean(Length_of_Stay,na.rm=T)) 
avg_los <- avg_los[order(-avg_los$avgl), ]  # Use order to rank them
cat("Hospitals with highest average patient stay duration:\n")
avg_los

# I used arrange as another method instead of using order to rank it in desc
# avg_los<- healthcare_data %>% group_by(Hospital) %>% summarise(avgl=mean(Length_of_Stay,na.rm=T)) %>% arrange(desc(avgl))
# View(avg_los)

# I'm currently not using this function but it basically takes in the date and converts it, it then stores the converted dates into the same columns
# convert_to_date <- function(date) {
#   as.Date(date, format = "%Y%m%d")
# }
# 
# # Apply the conversion function
# healthcare_data$Date.of.Admission <- convert_to_date(healthcare_data$Date.of.Admission)
# healthcare_data$Discharge.Date <- convert_to_date(healthcare_data$Discharge.Date)
# 
# healthcare_data$Length_of_Stay <- as.numeric(healthcare_data$Discharge.Date - healthcare_data$Date.of.Admission, units = "days")
# View(healthcare_data)


hospital_max <- avg_los[max(avg_los$avgl),]
hospital_max

# OR
# hospital_max <- avg_los %>%
#   arrange(desc(avgl)) %>%
#   slice(1)

hospital_with_max_los<-filter(healthcare_data,Length_of_Stay==30)
View(hospital_with_max_los)



i<-ggplot(avg_los,aes(x=Hospital,y=avgl))
i+geom_bar(stat='identity',size=2, fill = "skyblue") +
  labs(x = 'Hospitals', 
       y = 'Average Length of Stay (days)',
       title = 'Average Length of Stay by Hospital')+coord_flip() +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 8))
# Continue the plot


# 5 How do admission types(Emergency,Elective,Urgent)impact the billing amount and length of stay?

both_impact <- lm(cbind(Bill,Length_of_Stay) ~ Admission.Type, data= healthcare_data)
#  You need to use cbind() to combine the dependent variables or i can basically seperate them for each dependent variable i.e lm(Bill ~ Admission.Type, data= healthcare_data)  lm(Length_of_Stay ~ Admission.Type, data= healthcare_data)
summary(both_impact)


i<- ggplot(healthcare_data,aes(x=Admission.Type,y=Bill))
j<-i+geom_boxplot() +labs(title='Impact of Admission Type on Bill')
ggplotly(j)


i<- ggplot(healthcare_data,aes(x=Admission.Type,y=Length_of_Stay))
k<-i+geom_boxplot()+labs(title='Impact of Admission Type on Length of Stay')
ggplotly(k)


# 6 What is the gender distribution across different medical conditions?
#  Analyze the distrubution of male and female bpatients across various medical conditions to identify any gender-specific trends or disparities.

gender_dist_med<-healthcare_data%>%group_by(Gender,Medical.Condition)%>%summarise(count=n())
gender_dist_med


i<-ggplot(gender_dist_med,aes(x=Gender,y=count,fill=Medical.Condition))
p<-i+geom_bar(stat='identity')+labs(x='Gender',y='Proportion',title='Gender Distribution Across Medical Conditions')
ggplotly(p)


# 7 How do insurance providers impact the billing amount for similar medical conditions?
#  Compare the billing amounts for patients with the same medical conditions  but different insurance providers to see if there are significant differences in costs covered by various insurers,

insurance_bill_per_med<-healthcare_data%>%group_by(Insurance.Provider,Medical.Condition)%>%summarise(count=n(),avg_bill=mean(Bill,na.rm=TRUE))
insurance_bill_per_med


j<-ggplot(insurance_bill_per_med,aes(x=Insurance.Provider,y=avg_bill,fill=Medical.Condition))+
  geom_bar(stat='identity',position=position_dodge())+
  labs(x='Insurance Provider',y='Average Bill amount',title='Impact of insurance providers on Bill')+
theme(axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "top")

fig <- ggplotly(j)
fig



