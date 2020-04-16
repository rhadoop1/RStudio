library(tidyverse)
library(plotly)

load("koweps/welfare.rda")
summary(welfare)
#
# sex (질적자료, 명목자료, 범주형자료) 
#    1. NA 확인
table(is.na(welfare$sex))
#    2. outlier 확인
table(welfare$sex)
#    3. 1 => male, 2 ==> female
# welfare$sex = ifelse(welfare$sex==1, "male", "female")
#    3. table 빈도확인
table(welfare$sex)
#    4. qplot 빈도 막대 그래프
qplot(sex, data = welfare) %>% ggplotly()
(ggplot(welfare, aes(sex)) + geom_bar()) %>% ggplotly()
# income (양적자료, 연속형자료)
#    1. NA 확인
table(is.na(welfare$income))
#    2. extreme value 확인
welfare %>% filter(!is.na(income)) %>% 
            select(income) %>% 
            arrange(desc(income)) %>% head(20)

# welfare$income = ifelse(welfare$income==0, NA, welfare$income)
#    3. boxplot
boxplot(welfare$income)
qplot(x="total", y=income, data = welfare, geom='boxplot')
ggplot(welfare, aes(x="total", y=income)) + geom_boxplot()
#    4. histogram
qplot(income, data = welfare, breaks=seq(0, 2400, by=200))
ggplot(welfare, aes(x=income)) + geom_histogram(breaks=seq(0, 2400, by=500))
#
# income by sex
# 1. 평균 요약 데이블
library(sqldf)
sqldf("
        select sex, avg(income)
          from welfare
         group by sex
      ")
welfare %>% group_by(sex) %>% 
            summarise(mean_income=mean(income, na.rm = T)) -> incomebysex

# 2. incomebysex plot
incomebysex
ggplot(incomebysex, aes(sex, mean_income)) + geom_col()



