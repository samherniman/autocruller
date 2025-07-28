# Figured out how to get osm data for each building
# but can't figure out how to organize it

# figured out how to use stack to get the microsoft
# planetary comp building dataset metadata
# but don't know how to read the parquet files yet
# I think I need to use azurestor to get into the blob
# storage and then mess around with the urls

# https://planetarycomputer.microsoft.com/dataset/ms-buildings#Example-Notebook
# https://planetarycomputer.microsoft.com/docs/quickstarts/reading-stac-r/
# when you figure it out, answer this
# https://stackoverflow.com/questions/79620056/is-there-a-way-to-read-parquet-files-from-planetary-computer-in-r


library(osmdata)
id <- c (1489221200, 1489221321, 1489221491, 136190595, 136190596)
type <- c ("node", "node", "node", "way", "way")
datAiO <- opq_osm_id(id = id, type = type) |>
    opq_string() |>
    osmdata_sf()

ac_df <- ac_get_co2("download") 
ac_df_filtered <- ac_df[1:100,]

datAiO <- opq_osm_id(id = ac_df$nwrID, type = ac_df$nwrtype) |>
    opq_string() |>
    osmdata_sf() |> 
  unique_osmdata()

mapview::mapview(datAiO2$osm_points)

library(rstac)
# library(terra)

s_obj <- stac("https://planetarycomputer.microsoft.com/api/stac/v1/")
it_obj <- s_obj |> 
    stac_search(collections = "ms-buildings",
                bbox = c(-47.02148, -17.35063, -42.53906, -12.98314)) |> 
    get_request() |> 
    items_sign(sign_fn = sign_planetary_computer())

# need to figure out the az blob bit here
url <- paste0("/vsicurl/", it_obj$features[[1]]$assets$data$href)
buildings_sf <- stars::read_stars(url)
