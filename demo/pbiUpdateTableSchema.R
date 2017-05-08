library(poweRbi)

# Use populated (or empty) data frames to update tables in Power BI.
pbiUpdateTableSchema(
  data.frame(iris3),
  guid = "bf744ed5-cd51-4096-a473-150b80143582",
  tableName = "Iris Data Frame"
)
