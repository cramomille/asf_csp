
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

# Ouverture du fichier des iris
mar <- asf_mar()

# Selection des iris
iris <- mar$geom$irisrd
iris <- iris[, c(1,2,7)]
colnames(iris) <- c("IRIS_CODE", "IRIS_LIB", "P21_POP", "geometry")
st_geometry(iris) <- "geometry"

# Selection des iris de Mayotte
mayo <- mar$geom$irisf
mayo <- mayo[grepl("^976", mayo$IRISF_CODE), ]
mayo$P21_POP <- NA
mayo$P21_POP <- as.numeric(mayo$P21_POP)
mayo <- mayo[, c(1,2,7)]
colnames(mayo) <- c("IRIS_CODE", "IRIS_LIB", "P21_POP", "geometry")
st_geometry(mayo) <- "geometry"

# Collage des deux objets sf/data.frames
fond <- rbind(iris, mayo)

# Repositionnement des geometries des DROM
fond <- asf_drom(fond, id = "IRIS_CODE")


###############################################################################
######################################################### NETTOYAGE DES DONNEES

# Telechargement des donnees 
data <- read.csv2("input/TableTypo15.csv")
data <- data[, c(1, ncol(data))]

# Ajout des zeros manquants dans les identifiants
data$IRISr <- ifelse(nchar(data$IRISr) == 8,
                     paste0("0", data$IRISr),
                     data$IRISr)


###############################################################################
######################################## UTILISATION DES AUTRES FONCTIONS D'ASF

# Creation des zooms
zoom <- asf_zoom(fond = fond,
                 villes = c("Paris", "Marseille", "Lyon", "Toulouse", "Nantes", "Montpellier",
                            "Bordeaux", "Lille", "Rennes", "Reims", "Dijon","Strasbourg",
                            "Angers", "Grenoble", "Clermont-Ferrand", "Tours", "Perpignan",
                            "Besancon", "Rouen", "La Rochelle", "Le Havre", "Nice", "Mulhouse"
                 ),
                 buffer = 10000)

zooms <- zoom$zooms
labels <- zoom$labels

# Simplification des geometries du fond de carte principal
fond <- asf_simplify(fond, keep = 0.1)

# Jointure entre le fond et les donnees
fondata <- asf_fondata(data = data,
                       fond = fond,
                       zoom = zooms,
                       id = c("IRISr", "IRIS_CODE"))

palette <- c("01" = "#94282f",
             "02" = "#e40521",
             "03" = "#f07f3c",
             "04" = "#f7a941",
             "05" = "#ffd744",
             "06" = "#ffeea4",
             "07" = "#bbd043",
             "08" = "#6cbe99",
             "09" = "#bee2e9",
             "10" = "#86c2eb",
             "11" = "#04a64b",
             "12" = "#2581c4",
             "13" = "#aad29a",
             "14" = "#8779b7",
             "15" = "#554596"
             )

mf_map(fondata,
       var = "clust15", 
       type = "typo",
       pal = palette,
       border = NA)





test <- fond[grepl("^69", fond$IRIS_CODE), ]

carto <- asf_cartogram(test, var = "P21_POP", min = 2000)

mf_map(carto)

