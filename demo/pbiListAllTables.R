library(poweRbi)

#### 2. Get metadata about objects in your workspace. ------------------------

# Tables
pbiListAllTables(allDatasets = TRUE)

pbiListAllTables(id = "507be4b2-5bc1-4202-85c9-e22a4bde0777")
pbiListAllTables(id = c("guidA","guidB"))
