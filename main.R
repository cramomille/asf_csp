
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

# Recuperation des iris
url <- "https://sharedocs.huma-num.fr/wl/?id=Ho4XQWuOU2DLt7ppdE1Set3x3gsL3QbO&mode=grid&download=1"
iris <- st_read(url)

# # Table de passage vers les iris regroupes
# load("C:/Users/Antoine Beroud/Desktop/rexplo/input/mar/donnees/AR02_maille_IRISr.RData")
# tabl <- d.irisr.pass
# rm(d.irisr.app, d.irisr.etapes, d.irisr.pass, sf.irisr)
# 
# iris <- merge(iris, tabl, by = "IRIS_CODE")
# 
# irisar <- aggregate(iris, by = list(iris$IRISr_CODE), FUN = function(x) x[1])
# irisar <- irisar[, c(9,10)]

###############################################################################
################################################################### PACKAGE ASF

# Traitement sur les donnees --------------------------------------------------
data <- read.csv2("input/TableTypo15.csv")
data <- data[, c(1, ncol(data))]

data$IRISr <- ifelse(nchar(data$IRISr) == 8,
                     paste0("0", data$IRISr),
                     data$IRISr)

# Creation du fond et des zooms -----------------------------------------------
fond <- iris

zoom_created <- create_zoom(fond = fond,
                            villes = c("Paris", "Marseille", "Lyon", "Toulouse", "Nantes", "Montpellier",
                                       "Bordeaux", "Lille", "Rennes", "Reims", "Dijon","Strasbourg",
                                       "Angers", "Grenoble", "Clermont-Ferrand", "Tours", "Perpignan",
                                       "Besancon", "Rouen", "La Rochelle", "Le Havre", "Nice", "Mulhouse"
                            ),
                            buffer = 10000)

zooms <- zoom_created$zooms
labels <- zoom_created$labels

fond <- simplify_geom(fond, keep = 0.1)

fondata <- merge_fondata(data = data,
                         fond = fond,
                         zoom = zooms,
                         id = c("IRISr", "IRIS_CODE"))

palette <- c("1" = "#94282f",
             "2" = "#e40521",
             "3" = "#f28a3d",
             "4" = "#f9b342",
             "5" = "#ffdf43",
             "6" = "#ffec8d",
             "7" = "#bbd043",
             "8" = "#3fb498",
             "9" = "#bee2e9",
             "10" = "#86c2eb",
             "11" = "#92c56e",
             "12" = "#2581c4",
             "13" = "#50af47",
             "14" = "#7c6eb0",
             "15" = "#554596"
             )

mf_map(fondata,
       var = "clust15", 
       type = "typo",
       pal = palette,
       border = NA)


st_write(fondata, "test.gpkg")




