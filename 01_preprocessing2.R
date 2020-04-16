# h10_g3	성별(sex)
# h10_g4	태어난 연도(birth)
# h10_g10	혼인상태(marriage)
# h10_g11	종교(religion)
# h10_eco9	직종(code_job)
# p1002_8aq1	일한달의 월 평균 임금(income)
# h10_reg7	7개 권역별 지역구분(code_region)
library(tidyverse)
library(foreign)
library(readxl)
library(sas7bdat)

read.dta("koweps/Koweps_hpc10_2015_beta3.dta") %>%
# read.spss("koweps/Koweps_hpc10_2015_beta3.sav", to.data.frame = T) %>%
# read.sas7bdat("koweps/koweps_hpc10_2015_beta3.sas7bdat") %>%    
    rename(sex = h10_g3) %>%            # 성별(sex)
    rename(birth = h10_g4) %>%          # 태어난 연도(birth)
    rename(marriage = h10_g10) %>%      # 혼인상태(marriage)
    rename(religion = h10_g11) %>%      # 종교(religion)
    rename(income = p1002_8aq1) %>%     # 일한달의 월 평균 임금(income)
    rename(code_job = h10_eco9) %>%     # 직종(code_job)
    rename(code_region = h10_reg7) -> welfare  # 7개 권역별 지역구분(code_region)

welfare %<>% mutate(sex=ifelse(sex==1, "male", "female")) %>% 
             mutate(income=ifelse(income==0, NA, income)) %>% 
             mutate(age= 2015-birth+1) %>% 
             mutate(ageg=ifelse(age < 30, 'young',
                                ifelse(age < 60, 'middle', 'old'))) %>% 
             mutate(code_job=as.character(code_job)) %>% 
             mutate(code_job=ifelse(str_length(code_job)==3, 
                                            str_c("0", code_job), code_job)) %>%
             mutate(religion=ifelse(religion==1, "yes", "no")) %>% 
             mutate(group_marriage=(ifelse(marriage==1, "marriage",
                                          ifelse(marriage==3, "divorce", NA)))) %>%
             select(sex, 
                    birth, 
                    age,
                    ageg,
                    marriage, 
                    group_marriage,
                    religion,
                    income, 
                    code_job,
                    code_region) 

save(welfare, file="koweps/welfare.rda")
