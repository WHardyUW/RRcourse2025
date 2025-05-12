library(dplyr)
top_20_esg_2010 <- Data %>%
  filter(Year == 2010) %>%
  arrange(desc(ESG)) %>%
  top_n(ESG,20)
financial_data_2011 <- Data %>%
  filter(Year == 2011 & name %in% top_20_esg_2010$name & !is.na(Return))
csi300_2010 <- Data %>%
  filter(Year == 2010, CSI300 == 1) %>%
  select(name)
investment_portfolio_2011 <- Data %>%
  filter(Year == 2011, name %in% csi300_2010$name, !is.na(Return))