#
# 직종에 따른 월급 차이
#
load("koweps/welfare.rda")
load("koweps/occupation.rda")

welfare %>% filter(!is.na(income)) %>% 
            select(code_job, income) %>% 
            group_by(code_job) %>% 
            summarise(mean_income=mean(income)) -> incomebyjob

incomebyjob %>% left_join(occupation2, by="code_job") %>% 
                arrange(desc(mean_income)) %>% 
                head(10) %>% 
                mutate(rank="top10") -> top10

incomebyjob %>% left_join(occupation2, by="code_job") %>% 
                arrange(desc(mean_income)) %>% 
                tail(10) %>% 
                mutate(rank="bottom10")-> bottom10
                
top10 %>% bind_rows(bottom10) -> top_bottom10           

top_bottom10 %>% filter(rank=="top10") %>% 
                ggplot(aes(reorder(job, mean_income), mean_income)) + 
                    geom_col() +
                    coord_flip()

top_bottom10 %>% filter(rank=="bottom10") %>%  
                ggplot(aes(reorder(job, mean_income), mean_income)) + 
                            geom_col() +
                            coord_flip()

top_bottom10 %>% ggplot(aes(reorder(job, mean_income), mean_income)) + 
                geom_col() +
                coord_flip() +
                # facet_grid(cols = vars(rank), scales = "free")
                facet_grid(rows = vars(rank), scales = "free")




occupation2$job = str_replace_all(occupation2$job, "․", " ")
all(occupation1 == occupation2)
