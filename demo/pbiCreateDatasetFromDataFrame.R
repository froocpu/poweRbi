library(poweRbi)

# Create datasets from data frames.
pbiCreateDatasetFromDataFrame(
  name = "Iris Dataset3",
  df = iris,
  addRows = TRUE,
  tableName = "Iris Data Frame",
  FIFO = "basicFIFO"
)
