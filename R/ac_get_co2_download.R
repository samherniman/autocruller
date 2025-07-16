# # https://indoorco2map.com/chartdata/IndoorCO2MapData.zip
#   icm_response <-
#     httr2::request("https://indoorco2map.com/chartdata/IndoorCO2MapData.zip") |>
#     httr2::req_perform() |>
#     httr2::resp_body_json()
# obs_df <- here::here("data/raw/IndoorCO2MapData/indoorco2mapData.json") |> 
#   jsonlite::fromJSON() |> 
#   dplyr::mutate(
#     date = lubridate::as_datetime(startOfMeasurement),
#     day = lubridate::date(date)