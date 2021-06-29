using Turing

# https://turing.ml/dev/tutorials/7-poissonregression/
@model poisson_regression(traps, complaints) = begin
    α ~ Normal(log(4), .1)
    β ~ Normal(-0.25, .1)
    for i in eachindex(traps)
        λ = exp(α + β * traps[i])
        complaints[i] ~ Poisson(λ)
    end
end
