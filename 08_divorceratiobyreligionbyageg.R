library(tidyverse)
load("koweps/welfare.rda")
load("koweps/occupation.rda")

welfare %>% filter(!is.na(group_marriage)) %>% 
            filter(!is.na(religion)) %>% 
            group_by(religion, group_marriage) %>% 
            summarise(n = n()) %>% 
            mutate(tot=sum(n)) %>% 
            mutate(ratio=n/tot*100) %>% 
            filter(group_marriage=='divorce') -> divorceratiobyreligion1

divorcerationbyreligion1 %>% 
    ggplot(aes(religion, ratio)) + geom_col()

welfare %>% filter(!is.na(group_marriage)) %>% 
            filter(!is.na(religion)) %>% 
            count(religion, group_marriage) %>% 
            group_by(religion) %>% 
            mutate(tot=sum(n)) %>% 
            mutate(ratio=n/tot*100) %>% 
            filter(group_marriage=='divorce') -> divorceratiobyreligion2

divorceratiobyreligion2
library(sqldf)
sqldf("
        select * from welafare
      ") -> divorceratiobyreligion3

all(divorceratiobyreligion1==divorceratiobyreligion2)
all(divorceratiobyreligion1==divorceratiobyreligion3)

