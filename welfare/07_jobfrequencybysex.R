#
# 성별 직업 빈도(jobfrequencybysex)
#
library(tidyverse)
load("koweps/welfare.rda")
load("koweps/occupation.rda")

table(is.na(welfare$code_job))
# 1. 요약테이블 만들기
welfare %>% filter(!is.na(code_job)) %>% 
            filter(sex=="male") %>% 
            select(code_job) %>%
            group_by(code_job) %>% 
            summarise(n = n()) %>% 
            arrange(desc(n)) %>% 
            mutate(sex="male") %>% 
            head(10) -> jobfrequency_male10


welfare %>% filter(!is.na(code_job)) %>% 
            filter(sex=="female") %>% 
            select(code_job) %>%
            count(code_job) %>% 
            arrange(desc(n)) %>% 
            mutate(sex="female") %>% 
            head(10) -> jobfrequency_female10

jobfrequency_male10
jobfrequency_female10

jobfrequency_male10 %>% 
    bind_rows(jobfrequency_female10) %>% 
    left_join(occupation2, by="code_job") -> jobfrequecybysex

# 2. 그래프 그리기 (male_top10, female_top10)

jobfrequecybysex %>% filter(sex=="male") %>% 
    ggplot(aes(reorder(job, n), n)) + 
        geom_col() +
        coord_flip()

jobfrequecybysex %>% filter(sex=="female") %>% 
    ggplot(aes(reorder(job, n), n)) + 
    geom_col() +
    coord_flip()

jobfrequecybysex %>% filter(sex %in% c("male", "female")) %>% 
    mutate(sex=factor(sex, levels = c("male", "female"))) %>%
    ggplot(aes(reorder(job, n), n)) + 
    geom_col() +
    coord_flip() +
    facet_grid(rows = vars(sex), scales = "free")
