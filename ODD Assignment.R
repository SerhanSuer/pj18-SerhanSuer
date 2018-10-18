install.packages("tidyverse", repos = "https://cran.r-project.org")
library(tidyverse)

# Create a temporary file
tmp<-tempfile(fileext=".xlsx")
# Download file from repository to the temp file
download.file("https://github.com/MEF-BDA503/pj18-SerhanSuer/blob/master/odd_retail_sales_2018_06.xlsx?raw=true",destfile=tmp)
# Read that excel file using readxl package's read_excel function. You might need to adjust the parameters (skip, col_names) according to your raw file's format.
raw_data<-readxl::read_excel(tmp,skip=7,col_names=FALSE)
# Remove the temp file
file.remove(tmp)

# Remove the last two rows because they are irrelevant (total and empty rows)
raw_data <- raw_data %>% slice(-c(43,44))
# Let's see our raw data
head(raw_data)

# Use the same column names in your data.
colnames(raw_data) <- c("brand_name","auto_dom","auto_imp","auto_total","comm_dom","comm_imp","comm_total","total_dom","total_imp","total_total")
# Now we replace NA values with 0 and label the time period with year and month, so when we merge the data we won't be confused.
car_data_june_18 <- raw_data %>% mutate_if(is.numeric,funs(ifelse(is.na(.),0,.))) %>% mutate(year=2018,month=6)

print(car_data_june_18,width=Inf)

saveRDS(car_data_june_18,file="~/Documents/Folder/BDA/MEF/Data Analytics Essentials - Berk Orbay/odd_car_sales_data_june_18.rds")

# Only Domain
car_data_june_18 %>% 
    filter(total_imp == 0 & total_total != 0) %>%
    select(brand_name,total_total) %>%
    arrange(desc(total_total))

# Only Import
car_data_june_18 %>% 
    filter(total_dom == 0 & total_total != 0) %>%
    select(brand_name,total_total) %>%
    arrange(desc(total_total))

# Only Automobile
car_data_june_18 %>% 
    filter(comm_total == 0 & total_total != 0) %>%
    select(brand_name,total_total) %>%
    arrange(desc(total_total))

# Only Commercial
car_data_june_18 %>% 
    filter(auto_total == 0 & total_total != 0) %>%
    select(brand_name,total_total) %>%
    arrange(desc(total_total))
