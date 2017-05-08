library(poweRbi)

#### 1. Authenticate your session. -------------------------------------------
options(httr_oauth_cache = FALSE)
pbiAuthenticate(appName, clientId, clientSecret)

#### 2. Get metadata about objects in your workspace. ------------------------

# Datasets
pbiListAllDatasets()
pbiListAllDatasets(toDf = FALSE)

# Dashboards
pbiListAllDashboards()

# Imported files
pbiListAllImportedFiles()

# Reports
pbiListAllReports()

# Tables
pbiListAllTables(allDatasets = TRUE)
pbiListAllTables(id = "507be4b2-5bc1-4202-85c9-e22a4bde0777")

# Tiles
pbiListAllTiles(allDashboards = TRUE)
pbiListAllTiles(id = "cfbd4b32-3160-437b-8076-94e6cab9aa4a")

# Data sources
pbiListAllDataSources()

# User groups
pbiListAllUserGroups()

#### 3. Create datasets from data frames. ------------------------------------
pbiCreateDatasetFromDataFrame(
  name = "Iris Dataset3",
  df = iris,
  addRows = TRUE,
  tableName = "Iris Data Frame",
  FIFO = "basicFIFO"
)

#### 4. Manage existing datasets. --------------------------------------------

# Use populated (or empty) data frames to update tables in Power BI.
pbiUpdateTableSchema(
  data.frame(iris3),
  guid = "bf744ed5-cd51-4096-a473-150b80143582",
  tableName = "Iris Data Frame"
)

# Truncate tables.
pbiTruncateDataset(
  guid = "bf744ed5-cd51-4096-a473-150b80143582",
  tableName = "Iris Data Frame"
)

# Delete entire datasets.
pbiDeleteDataset(guid = "bf744ed5-cd51-4096-a473-150b80143582")

# Create new rows.
pbiAddRowsToTable(
  df = iris,
  guid = "b765f9c4-17b4-4371-b7e6-f510288f8204",
  tableName = "Iris Data Frame"
)

#### 5. Utilities. -----------------------------------------------------------

# What data types does Power BI implement?
pbiDataTypes(simple = TRUE, verbose = FALSE)
pbiDatasetTypes()

# Infer data types from a data frame.
sapply(MASS::cats, ._pbiGetDataType)

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

# Automatic token refreshing.
._pbiRefresh()
._pbiTokenExpiresIn()
