using DataFrames
using CategoricalArrays
using Dates

using RCall
let dir = datadir("pest_data.rds")
    R"""
    library(dplyr)
    library(lubridate)

    pest_data <- readRDS($dir)
        N_buildings <- length(unique(pest_data$building_id))
    """
end

R"""
N_months <- length(unique(pest_data$date))

# Add some IDs for building and month
pest_data <- pest_data %>%
  mutate(
    building_fac = factor(building_id, levels = unique(building_id)),
    building_idx = as.integer(building_fac),
    ids = rep(1:N_months, N_buildings),
    mo_idx = lubridate::month(date)
  )
"""

R"""
# Center and rescale the building specific data
building_data <- pest_data %>%
    select(
      building_idx,
      live_in_super,
      age_of_building,
      total_sq_foot,
      average_tenant_age,
      monthly_average_rent
    ) %>%
    unique() %>%
    arrange(building_idx) %>%
    select(-building_idx) %>%
    scale(scale=FALSE) %>%
    as.data.frame() %>%
    mutate( # scale by constants
      age_of_building = age_of_building / 10,
      total_sq_foot = total_sq_foot / 10000,
      average_tenant_age = average_tenant_age / 10,
      monthly_average_rent = monthly_average_rent / 1000
    ) %>%
    as.matrix()
"""

# TODO: Fix the sorting in the Julia version
building_data_r = rcopy(R"building_data")


# Data maniplation in Julia

pest_data.building_fac = categorical(pest_data.building_id)
pest_data.building_idx = levelcode.(pest_data.building_fac)

pest_data.mo_idx = month.(pest_data.date)
n_months = length(unique(pest_data.date))
n_buildings = length(unique(pest_data.building_id))
pest_data.ids = repeat(1:n_months, n_buildings)

using MLDataUtils

building_data = pest_data[:, [:building_idx, :live_in_super, :age_of_building, :total_sq_foot,
        :average_tenant_age, :monthly_average_rent]]
building_data = select(sort(unique(building_data), :building_idx), Not(:building_idx))
μ = center!(building_data)

building_data.age_of_building = building_data.age_of_building ./ 10
building_data.total_sq_foot = building_data.total_sq_foot ./ 10000
building_data.average_tenant_age = building_data.average_tenant_age ./ 10
building_data.monthly_average_rent = building_data.monthly_average_rent ./ 1000;

building_data_julia = Matrix(building_data)

building_data = building_data_r
