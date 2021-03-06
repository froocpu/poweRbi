
<!-- README.md is generated from README.Rmd. Please edit that file -->
poweRbi
=======

An R-based, httr-style interface for the Power BI REST API. Inspired by the work of libraries like twitteR and httr in R, this library aims to provide a useful set of tools for navigating the (fairly limited) Power BI REST API for their web services.

You will need to register an app before you can use this library: <https://powerbi.microsoft.com/en-us/documentation/powerbi-developer-overview-of-power-bi-rest-api/>

### Overview

The package satisfies five main functions:

-   Handles OAuth 2.0 authentication between R sessions and Power BI applications.
-   Pulls metadata about datasets, dashboards and tiles, reports, import files and user groups.
-   Creates datasets, imports data frames as tables and streams data to Power BI tables.
-   Managing existing datasets with update, truncation and delete functions.
-   Provides utilities to infer data types and generate list/JSON objects from data frames.

Some use cases :

-   Streaming data from an external source to a Streaming or PushStreaming Power BI dataset.
-   Creating datasets and tables on the fly and storing the results of R scripts on a Power BI web service.
-   Maintaining datasets, reports and dashboards.
-   Using URLs from report metadata to embed reports as iframes inside your own application.

#### Before installing:

This is still in development and fairly experimental. Much of the functionality is ready to use, so if there are any significant improvements that can be made during this process then feel free to make changes and contribute as you please.

``` r
install.packages("devtools") # If required.
devtools::install_github("olfrost/poweRbi")
```

### Examples

See the demo directory for the full code examples for the following:

``` r
library(poweRbi)
```

All functions are prefixed with "pbi" to enable faster lookup.

#### Authenticate your session.

``` r
pbiAuthenticate(appName, clientId, clientSecret) # This will take you to a sign-in page, or you can cache your authentication details as a .httr-oauth file.
```

#### Get metadata about objects in your workspace

``` r
# Datasets
pbiListAllDatasets(toDf = FALSE) # Be flexible on whether your data is returned as a list or as a data frame.

# Dashboards
pbiListAllDashboards(toDf = TRUE)

# Imported files
pbiListAllImportedFiles(toDf = TRUE)

# Reports
pbiListAllReports(toDf = TRUE)

# Tables
pbiListAllTables(allDatasets = TRUE)
pbiListAllTables(id = "cfcf6cde-45b7-459d-a8a3-a09644f5cbbe") # A single guid, multiple guids or all.

# Tiles
pbiListAllTiles(allDashboards = TRUE)
pbiListAllTiles(id = "cfbd4b32-3160-437b-8076-94e6cab9aa4a")

# Data sources
pbiListAllDataSources()

# User groups
pbiListAllUserGroups()
```

#### Create datasets from data frames

``` r
pbiCreateDatasetFromDataFrame(
  name = "Iris Dataset",
  df = iris,
  tableName = "Iris Data Frame",
  FIFO = "basicFIFO" # Enable basic first-in-first-out for streaming.
)
```

#### Manage existing datasets

``` r
# Use populated (or empty) data frames to update tables in Power BI.
pbiUpdateTableSchema(
  iris3, # Overwrite table schemas.
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
  df = cats, # Use this function to stream data into an appropriate dataset.
  guid = "abcdef",
  tableName = "Iris Data Frame"
)
```

#### Utilities

``` r
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
._pbiRefresh() # All handled automatically by pbi functions.
._pbiTokenExpiresIn()
```
