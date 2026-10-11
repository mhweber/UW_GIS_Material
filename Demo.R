# C:/Users/mwebe/OneDrive/UW Program/GISPR/Module 3/GISPR_Module3_Data/data
# parcels.gdb
# salmon_watersheds.gdb
library(arcgisbinding)
library(sf)
arc.check_product()

# Open and select
arc_obj  <- arc.open("C:/Users/mwebe/OneDrive/UW Program/GISPR/Module 3/GISPR_Module3_Data/data/parcels.gdb/Parcels")
arc_data <- arc.select(arc_obj,
                       fields = c("PARCEL_ID","AREA_SQFT"))

# Convert to sf
parcels_sf <- arc.data2sf(arc_data)

# Standard checks
st_crs(parcels_sf)$epsg       # 2926
nrow(parcels_sf)               # row count
st_geometry_type(parcels_sf[1,]) # POLYGON
head(parcels_sf)
plot(parcels_sf$geom)


parcels <- st_read("C:/Users/mwebe/OneDrive/UW Program/GISPR/Module 3/GISPR_Module3_Data/data/parcels.gdb",layer="Parcels")
boundary <- st_read("C:/Users/mwebe/OneDrive/UW Program/GISPR/Module 3/GISPR_Module3_Data/data/salmon_watersheds.gpkg",
                    query = "SELECT * FROM watersheds WHERE HUC12 = '171100120201'")
parcels <- st_transform(
  parcels, st_crs(boundary))

# CLIP
clipped <- st_intersection(parcels, boundary)

# DIFFERENCE
outside <- st_difference(parcels, boundary)

# UNION
combined <- st_union(parcels, boundary)
