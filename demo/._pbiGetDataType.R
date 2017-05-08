library(poweRbi)
library(MASS)

# Infer data types from a data frame.
sapply(MASS::cats, ._pbiGetDataType)
