library(poweRbi)

#### 1. Authenticate your session. -------------------------------------------
options(httr_oauth_cache = FALSE)
pbiAuthenticate(appName, clientId, clientSecret) ## fix readRDS

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
pbiListAllTables(id = "cfcf6cde-45b7-459d-a8a3-a09644f5cbbe")

# Tiles
pbiListAllTiles(allDashboards = TRUE)
pbiListAllTiles(id = "cfbd4b32-3160-437b-8076-94e6cab9aa4a")

# Data sources
pbiListAllDataSources()

# User groups
pbiListAllUserGroups()

#### 3. Create datasets from data frames. ------------------------------------
pbiCreateDatasetFromDataFrame(
  name = "Iris Dataset",
  df = iris,
  tableName = "Iris Data Frame",
  FIFO = "basicFIFO"
)

#### 4. Manage existing datasets. --------------------------------------------

# Use populated (or empty) data frames to update tables in Power BI.
pbiUpdateTableSchema(
  iris3,
  guid = "abcdefg",
  tableName = "Iris Data Frame"
)

# Truncate tables.
pbiTruncateDataset(
  guid = "cfcf6cde-45b7-459d-a8a3-a09644f5cbbe",
  tableName = "Triangle"
)

# Delete entire datasets.
pbiDeleteDataset(guid = "cfcf6cde-45b7-459d-a8a3-a09644f5cbbe")

# Create new rows.
pbiAddRowsToTable(
  df = cats,
  guid = "abcdef",
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
