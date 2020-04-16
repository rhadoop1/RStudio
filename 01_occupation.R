library(tidyverse)
library(readxl)

occupation1 = read_excel("Data/Koweps_Codebook.xlsx", sheet = 2)
occupation1$code_job = str_pad(occupation1$code_job, width = 4, side="left", pad = "0")
occupation1

occupation2 = read_excel("Data/Koweps_Codebook.xlsx", sheet = 3, col_names = F)
occupation2$code_job = str_sub(occupation2$...1, 1, 4)
occupation2$job = str_sub(occupation2$...1, 5)
occupation2$job = str_trim(occupation2$job)
occupation2$...1 = NULL

occupation1
occupation2

all(occupation1$code_job == occupation2$code_job)
all(occupation1$job == occupation2$job)
table(occupation1$job == occupation2$job)

cbind(occupation1, occupation2) -> confirm_df

confirm_df[!(occupation1$job == occupation2$job), c(2,4)] %>% View()

save(occupation1, occupation2, file="koweps/occupation.rda")


