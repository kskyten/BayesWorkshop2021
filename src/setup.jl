using Random
Random.seed!(Random.GLOBAL_RNG, 123)

include("posterior_predictive.jl")
include("bayesplot.jl")

using Dates
using Feather
pest_data = Feather.read(joinpath(datadir(), "pest_data.feather"))
pest_data.date = convert.(Date, pest_data.date);
