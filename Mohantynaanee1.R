# ---------------------------------------------
# Data Analysis Using R Programming
# Technologies: ggplot2, dplyr, caret, missForest
# ---------------------------------------------

# Load libraries
library(dplyr)
library(ggplot2)
library(caret)
library(missForest)

# -----------------------------
# 0️⃣ Create directories to save outputs
# -----------------------------
dir.create("C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R", showWarnings = FALSE)
dir.create("C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/plots", showWarnings = FALSE)

# -----------------------------
# 1️⃣ Load Data
# -----------------------------
dataset_path <- "C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/customer_churn1.csv"
customerchurn <- read.csv(dataset_path, stringsAsFactors = FALSE)

glimpse(customerchurn)
summary(customerchurn)

# -----------------------------
# 2️⃣ Data Cleaning
# -----------------------------
customerchurn$MonthlyCharges <- as.numeric(as.character(customerchurn$MonthlyCharges))
customerchurn$tenure <- as.numeric(as.character(customerchurn$tenure))
customerchurn$TotalCharges <- as.numeric(as.character(customerchurn$TotalCharges))

# Exclude customerID from imputation
customerchurn_for_impute <- customerchurn %>% select(-customerID)

cat_cols <- c("gender", "Partner", "Dependents", "PhoneService", "MultipleLines",
              "InternetService", "OnlineSecurity", "OnlineBackup", "DeviceProtection",
              "TechSupport", "StreamingTV", "StreamingMovies", "Contract",
              "PaperlessBilling", "PaymentMethod", "Churn")

customerchurn_for_impute[cat_cols] <- lapply(customerchurn_for_impute[cat_cols], as.factor)
num_cols <- c("tenure", "MonthlyCharges", "TotalCharges")
customerchurn_for_impute[num_cols] <- lapply(customerchurn_for_impute[num_cols], as.numeric)

set.seed(123)
customerchurn_clean <- missForest(customerchurn_for_impute)$ximp
customerchurn_clean$customerID <- customerchurn$customerID

cat("Number of missing values after imputation:", sum(is.na(customerchurn_clean)), "\n")

# -----------------------------
# 3️⃣ Gender Analysis
# -----------------------------
customerchurn_clean$gender <- ifelse(customerchurn_clean$gender == "Male", 1, 0)
Male <- sum(customerchurn_clean$gender == 1)
Female <- sum(customerchurn_clean$gender == 0)
cat("Male:", Male, "Female:", Female, "\n")

gender_data <- data.frame(Gender = c("Male", "Female"), Count = c(Male, Female))
gender_plot <- ggplot(gender_data, aes(x = Gender, y = Count, fill = Gender)) +
  geom_bar(stat = "identity") +
  labs(title = "Gender Distribution", y = "Count") +
  scale_fill_manual(values = c("blue", "pink")) +
  theme_minimal()

print(gender_plot)
ggsave("C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/plots/gender_distribution.png",
       plot = gender_plot, width = 6, height = 4)

# -----------------------------
# 4️⃣ Senior Citizens Gender Analysis
# -----------------------------
customerchurn_clean$SeniorCitizen <- ifelse(customerchurn_clean$SeniorCitizen == "1", "Yes", "No")
old <- subset(customerchurn_clean, SeniorCitizen == "Yes")
oldmale <- sum(old$gender == 1)
oldfemale <- sum(old$gender == 0)
cat("Senior Male:", oldmale, "Senior Female:", oldfemale, "\n")

png("C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/plots/senior_gender_distribution.png", width=800, height=600)
barplot(c(oldmale, oldfemale),
        names.arg = c("Male", "Female"),
        col = c("blue", "pink"),
        main = "Senior Citizens Gender Distribution",
        ylab = "Count")
dev.off()

# -----------------------------
# 5️⃣ Internet Service Distribution
# -----------------------------
nointernet <- sum(customerchurn_clean$InternetService == "No")
haveinternet <- sum(customerchurn_clean$InternetService != "No")
cat("No Internet:", nointernet, "Has Internet:", haveinternet, "\n")

d <- c(nointernet, haveinternet)
percentages <- round(d / sum(d) * 100, 1)
labels <- paste(c("No Internet", "Has Internet"), "\n", d, " (", percentages, "%)", sep = "")

png("C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/plots/internet_service_distribution.png", width=800, height=600)
pie(d, labels = labels, col = c("red", "green"), main = "Internet Service Distribution")
dev.off()

# -----------------------------
# 6️⃣ Phone Service Analysis
# -----------------------------
nophone <- sum(customerchurn_clean$PhoneService == "No")
havephone <- sum(customerchurn_clean$PhoneService == "Yes")
bothphoneandmulti <- sum(customerchurn_clean$PhoneService == "Yes" & customerchurn_clean$MultipleLines == "Yes")
cat("No Phone:", nophone, "Phone without Multi:", (havephone - bothphoneandmulti),
    "Phone with Multi:", bothphoneandmulti, "\n")

phone_service_data <- data.frame(
  Category = c("No Phone Service", "Has Phone Without Multiple Lines", "Has Phone With Multiple Lines"),
  Count = c(nophone, havephone - bothphoneandmulti, bothphoneandmulti)
)

phone_plot <- ggplot(phone_service_data, aes(x = Category, y = Count, fill = Category)) +
  geom_bar(stat = "identity") +
  labs(title = "Phone Service Distribution", x = "Category", y = "Count") +
  scale_fill_manual(values = c("lightblue", "lightgreen", "lightcoral")) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(phone_plot)
ggsave("C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/plots/phone_service_distribution.png",
       plot = phone_plot, width = 7, height = 5)

# -----------------------------
# 7️⃣ Payment Method Distribution
# -----------------------------
payment_counts <- customerchurn_clean %>%
  group_by(PaymentMethod) %>%
  summarise(Count = n())
payment_counts$Percentage <- round(100 * payment_counts$Count / sum(payment_counts$Count), 1)
print(payment_counts)

payment_plot <- ggplot(payment_counts, aes(x = reorder(PaymentMethod, -Count), y = Count, fill = PaymentMethod)) +
  geom_bar(stat = "identity") +
  labs(title = "Payment Methods Distribution", x = "Payment Method", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3")

print(payment_plot)
ggsave("C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/plots/payment_methods_distribution.png",
       plot = payment_plot, width = 8, height = 5)

# -----------------------------
# 8️⃣ TotalCharges Analysis
# -----------------------------
totalcharges_summary <- customerchurn_clean %>%
  mutate(Range = cut(TotalCharges, breaks = seq(0, 10000, by = 1000), include.lowest = TRUE)) %>%
  group_by(Range) %>%
  summarise(Count = n())
print(totalcharges_summary)

totalcharges_plot <- ggplot(totalcharges_summary, aes(x = Range, y = Count, group = 1)) +
  geom_line(color = "blue") +
  geom_point(color = "red") +
  labs(title = "TotalCharges Distribution", x = "Range", y = "Count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(totalcharges_plot)
ggsave("C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/plots/totalcharges_distribution.png",
       plot = totalcharges_plot, width = 8, height = 5)

# -----------------------------
# 9️⃣ Summary Outputs
# -----------------------------
cat("Max TotalCharges:", max(customerchurn_clean$TotalCharges), "\n")
cat("Min TotalCharges:", min(customerchurn_clean$TotalCharges), "\n")
cat("Mean TotalCharges:", mean(customerchurn_clean$TotalCharges), "\n")
cat("Median TotalCharges:", median(customerchurn_clean$TotalCharges), "\n")

# -----------------------------
# 🔟 Save Cleaned Data
# -----------------------------
write.csv(customerchurn_clean,
          "C:/Users/aditya/3D Objects/Data-Analysis-Customer-Churn-R/customerchurn_cleaned.csv",
          row.names = FALSE)
cat("Cleaned dataset saved!\n")
