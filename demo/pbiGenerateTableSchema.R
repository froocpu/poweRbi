library(poweRbi)
library(MASS)

# Generate JSON objects or lists from data frames to be passed to Power BI.
pbiGenerateTableSchema(
  MASS::cats,
  tableName = "Many Cats"
)

pbiGenerateTableSchema(
  MASS::cats,
  debug = TRUE,
  tableName = "Meowsers in my Trousers"
)
