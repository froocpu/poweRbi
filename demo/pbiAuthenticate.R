library(poweRbi)
library(MASS)
library(datasets)
library(utils)

#### 1. Authenticate your session. -------------------------------------------
options(httr_oauth_cache = FALSE)
pbiAuthenticate(appName, clientId, clientSecret)
