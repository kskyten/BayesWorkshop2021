using RCall
bayesplot =  rimport("bayesplot")

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

function ppc_dens_overlay(y, yrep; kwargs...)
    # TableTraits.isiterabletable(yrep) || error("Argument `yrep` is not an iterable table.")
    @assert length(y) == size(yrep, 2)
    bayesplot.ppc_deens_overlay(y, DataFrame(yrep); kwargs...)
end
