library(tidyverse)
library(sqldf)
library(plotly)

load("koweps/welfare.rda")
summary(welfare$birth)
table(is.na(welfare$birth))
welfare[order(welfare$birth), 'birth'] %>% head
welfare[order(-welfare$birth), 'birth'] %>% head
qplot(x="group", y=birth, data = welfare, geom="boxplot")
qplot(x=birth, data = welfare, geom="histogram", breaks=seq(1900, 2014, by=20))

# age 파생변수를 만들자.
# welfare$age = 2015 - welfare$birth + 1
summary(welfare$age)
table(is.na(welfare$age))
welfare[order(welfare$age), 'age'] %>% head
welfare[order(-welfare$age), 'age'] %>% head
qplot(x="group", y=age, data = welfare, geom="boxplot")
qplot(x=age, data = welfare, geom="histogram", breaks=seq(0, 120, by=10))

# 2. incomebyage
#   ㄱ. 나이별 평균 월급 요약표
welfare %>% filter(!is.na(income)) %>% 
            group_by(age) %>% 
            summarise(mean=mean(income)) -> incomebyage
#    L. 라인 차트 그리기
incomebyage
ggplot(incomebyage, aes(age, mean)) + geom_line() -> incomebyage_plot
ggplot_build(incomebyage_plot)
ggplotly(incomebyage_plot)


