library(tidyverse)
library(sqldf)

load("koweps/welfare.rda")

# 1. 연령대 및 성별 월급 평균표 만들기
welfare %>% filter(!is.na(income)) %>% 
            select(sex, ageg, income) %>% 
            group_by(ageg, sex) %>% 
            summarise(mean_income=mean(income)) -> incomebysexbyageg

# 2. 막대 그래프 (x=ageg, y=mean_income, fill=sex)
incomebysexbyageg %>% ggplot(aes(ageg, mean_income, fill=sex)) +
                        geom_bar(stat="identity", position = "dodge") +
                        scale_x_discrete(limits=c("young", "middle", "old"))


