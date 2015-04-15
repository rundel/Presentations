# Day of the week 
park %>% 
  select(`Registration State`, `Issue Date`, `Violation Time`) %>% 
  mutate(datetime = mdy_hm(paste(`Issue Date`, `Violation Time`))) %>% 
  select(-`Issue Date`, -`Violation Time`) %>% 
  mutate(ny_reg = c("Other","NY")[(`Registration State` == "NY") + 1],
         wday = wday(`datetime`, label=TRUE)) %>%
  group_by(`ny_reg`, `wday`) %>%
  summarize(n = n())


# Hour of the day

park %>% 
  select(`Registration State`, `Issue Date`, `Violation Time`) %>% 
  mutate(datetime = mdy_hm(paste(`Issue Date`, `Violation Time`))) %>% 
  select(-`Issue Date`, -`Violation Time`) %>% 
  mutate(ny_reg = c("Other","NY")[(`Registration State` == "NY") + 1],
         hour = hour(`datetime`)) %>%
  group_by(`ny_reg`, `hour`) %>%
  summarize(n = n())


# Hour and day of the week

park %>% 
  select(`Registration State`, `Issue Date`, `Violation Time`) %>% 
  mutate(datetime = mdy_hm(paste(`Issue Date`, `Violation Time`))) %>% 
  select(-`Issue Date`, -`Violation Time`) %>% 
  mutate(ny_reg = c("Other","NY")[(`Registration State` == "NY") + 1], 
         hour = hour(`datetime`),
         wday = wday(`datetime`, label=TRUE)) %>%
  group_by(`ny_reg`, `wday`, `hour`) %>%
  summarize(n = n())



# Billboard Data Tidying

bb %>%
  gather(week, ranking, wk1:wk76, na.rm=TRUE) %>% 
  arrange(`track`, `artist`, `week`)