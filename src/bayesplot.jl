using RCall
using DataFrames

bayesplot =  rimport("bayesplot")

# https://github.com/JuliaInterop/RCall.jl/issues/333

function mcmc_recover_hist(posterior, true_parameters; kwargs...)
    #TableTraits.isiterabletable(posterior) || error("Argument `posterior` is not an iterable table.")
    df = DataFrame(posterior)
    cols = Symbol.(names(df))
    true_params = Float64[]
    for c in cols
        val = get(true_parameters, c) do
            error("Did not find key $c in `true_parameters`.")
        end
        push!(true_params, val)
    end
    bayesplot.mcmc_recover_hist(df, true_params; kwargs...)
end

function _ppc_conv(y, yrep::Vector{<:NamedTuple})
    @assert length(first(yrep)) == 1
    @assert length(y) == length(yrep[1][1])
    ymat = transpose(reduce(hcat, map(first, yrep)))
    (y, ymat)
end

function ppc_dens_overlay(y, yrep; kwargs...)
    bayesplot.ppc_dens_overlay(_ppc_conv(y, yrep)...; kwargs...)
end

function ppc_rootogram(y, yrep; kwargs...)
    bayesplot.ppc_rootogram(_ppc_conv(y, yrep)...; kwargs...)
end

function ppc_stat(y, yrep; kwargs...)
    bayesplot.ppc_stat(_ppc_conv(y, yrep)...; kwargs...)
end

function ppc_intervals(y, yrep; kwargs...)
    bayesplot.ppc_intervals(_ppc_conv(y, yrep)...; kwargs...)
end

function ppc_stat_grouped(y, yrep; kwargs...)
    bayesplot.ppc_stat_grouped(_ppc_conv(y, yrep)...; kwargs...)
end

function mcmc_hist(x; kwargs...)
    bayesplot.mcmc_hist(x; kwargs...)
end

function mcmc_trace(x; kwargs...)
    bayesplot.mcmc_trace(x; kwargs...)
end

function mcmc_scatter(x; kwargs...)
    bayesplot.mcmc_scatter(x; kwargs...)
end

function mcmc_parcoord(x; kwargs...)
    bayesplot.mcmc_parcoord(x; kwargs...)
end

function mcmc_areas(x; kwargs...)
    bayesplot.mcmc_areas(x; kwargs...)
end

function bayesplot_grid(plots...; kwargs...)
    bayesplot.bayesplot_grid(plots...; kwargs...)
end
