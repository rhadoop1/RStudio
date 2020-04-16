library(tidyverse)
load("koweps/welfare.rda")
load("koweps/occupation.rda")
# 혼인상태(marriage)	"0.비해당(18세 미만)
#                        1.유배우         2.사별         3.이혼          4.별거          
#                        5.미혼(18세이상, 미혼모 포함)   6.기타(사망 등)"
# 종교(religion)	1.있음                2.없음
class(welfare$religion)
table(welfare$religion)
table(is.na(welfare$religion))
table(welfare$group_marriage)
# welfare %>% mutate(religion=ifelse(religion==1, "yes", "no")) %>% 
#             mutate(group_marriage=(ifelse(marriage==1, "marriage",
#                                           ifelse(marriage==3, "divorse", NA)))) %>% 
#             select(religion, group_marriage) %>% count(religion, group_marriage)

# 1. 비율을 구하는 방법 (group_by)
as_tibble(welfare) %>% 
            filter(!is.na(group_marriage)) %>% 
            filter(!is.na(religion)) %>%
            select(group_marriage, religion) %>% 
            group_by(group_marriage) %>% 
            summarise(n = n()) %>% 
            mutate(tot=sum(n)) %>% 
            mutate(ratio=n/tot*100) -> ratio1

# 2. 비율을 구하는 방법 (count)
as_tibble(welfare) %>% 
            filter(!is.na(group_marriage)) %>% 
            filter(!is.na(religion)) %>%
            select(group_marriage, religion) %>%
            count(group_marriage) %>% 
            mutate(tot=sum(n)) %>% 
            mutate(ratio=n/tot*100) -> ratio2

ratio2
library(sqldf)
sqldf("
        select  group_marriage, count(group_marriage) as n
        from welfare
        where group_marriage is not null
        group by group_marriage
      ")
sqldf("
        select count(group_marriage) as tot
        from welfare
        where group_marriage is not null
      ")

sqldf("select group_marriage, n, tot, 1.*n/tot*100 as ratio
         from
            (
            select  group_marriage, count(group_marriage) as n
              from welfare
             where group_marriage is not null
             group by group_marriage
            ) x,
            (
            select count(group_marriage) as tot
              from welfare
             where group_marriage is not null
            ) y
      ") -> ratio3


all(ratio1 == ratio2)            
all(ratio1 == ratio3)  






