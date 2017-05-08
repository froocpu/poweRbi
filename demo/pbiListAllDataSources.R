library(poweRbi)

# Data sources
pbiListAllDataSources(allDatasets = TRUE)

pbiListAllDataSources(id = "someGuid")
pbiListAllDataSources(id = c("someGuid","someGuid2"))
