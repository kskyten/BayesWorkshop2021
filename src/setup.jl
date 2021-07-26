using Random
Random.seed!(Random.GLOBAL_RNG, 123)

using Turing

include("posterior_predictive.jl")
include("bayesplot.jl")
include("arviz.jl")

using Dates
using Feather
const pest_data = let data = Feather.read(joinpath(datadir(), "pest_data.feather"))
    data.date = convert.(Date, data.date);
    DataFrame((n => Array(data[:, n]) for n in names(data))...)
end
