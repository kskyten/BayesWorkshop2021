using Distributions

function poisson_dgp(N, mean_traps)
    α = rand(Normal(log(4), .1))
    β = rand(Normal(-0.25, .1))
    traps = rand(Poisson(mean_traps), N)
    complaints = similar(traps)
    for i in eachindex(traps)
        complaints[i] = rand(Poisson(exp(α + β * traps[i])))
    end

    return (α = α, β = β, traps = traps, complaints = complaints)
end
