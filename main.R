
#                                 EXPLORATIONS POUR LA PLANCHE SUR L'IMMOBILIER
#
#                                                                antoine beroud
#                                                                  jean riviere
#                                                                  aliette roux

library(sf)
library(asf)
library(mapsf)


###############################################################################
############################################################### FONDS D'ALIETTE

# Recuperation des fonds de reference
load("C:/Users/Antoine Beroud/Desktop/rexplo/input/mar/donnees/AR01_geog_constante.RData")
tabl_com <- d.comf.pass
tabl_com <- tabl_com[, c(1,4)]

# Recuperation des communes regroupees
load("C:/Users/Antoine Beroud/Desktop/rexplo/input/mar/donnees/AR02_maille_IRISr.RData")
iris <- sf.irisr

# Agregation en communes
com <- aggregate(iris, by = list(iris$COMF_CODE_MULTI), FUN = function(x) x[1])
com <- com[, c(1,7,10)]
com <- st_as_sf(com)
com <- st_transform(com, 2154)

colnames(com)[1] <- "comar"

summary(nchar(com$comar))

# Decomposition des identifiants agreges en une liste
list_id <- strsplit(com$comar, " \\| ")

# Creation d'une table d'association entre chaque commune et son regroupement de communes
tabl_id <- data.frame(
  COMF_CODE = unlist(list_id),
  comar = rep(com$comar, sapply(list_id, length))
)

summary(nchar(tabl_id$comar))

# Creation d'une table de passage globale
tabl <- merge(tabl_com, tabl_id, by = "COMF_CODE", all = TRUE)
tabl <- tabl[, c(2,1,3)]
# tabl <- tabl[!grepl("75056|13055|69123", tabl$COMF_CODE), ]

# Suppression des donnees inutilisees
rm(d.comf.app, d.comf.pass, d.irisf.pass, sf.comf, sf.irisf)
rm(d.irisr.app, d.irisr.etapes, d.irisr.pass, sf.irisr)
rm(iris, com, list_id, tabl_com, tabl_id)


###############################################################################
###############################################################################
