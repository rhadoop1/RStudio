#
# 연령대에 따른 입금 차이 분석(incomebyageg)
#
# 1. incomebysex
# 2. incomebyage
# 3. incomebyageg
#
library(tidyverse)
library(sqldf)
load("koweps/welfare.rda")

welfare$ageg = ifelse(welfare$age < 30, 'young',
                      ifelse(welfare$age < 60, 'middle', 'old'))
summary(welfare$ageg)
table(is.na(welfare$ageg))
table(welfare$ageg)
qplot(welfare$ageg)

welfare %>% filter(!is.na(income)) %>% 
            select(ageg, income) %>% 
            group_by(ageg) %>% 
            summarise(mean_income=mean(income)) -> incomebyageg

sqldf("
      
      ") -> incomebyageg_sql


incomebyageg %>% ggplot(aes(ageg, mean_income)) +
                        geom_bar(stat="identity") +
                        scale_x_discrete(limits=c('young', 'middle', 'old'))
    
    
