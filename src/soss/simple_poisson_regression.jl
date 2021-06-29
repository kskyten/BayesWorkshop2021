using Soss

simple_poisson = @model traps begin
    α ~ Normal(log(4), .1)
    β ~ Normal(-0.25, .1)

    complaints ~ For(eachindex(traps)) do i
        λ = exp(α + β * traps[i])
        Poisson(λ)
    end
end

alt_poisson = @model (N, mean_traps) begin
    traps ~ For(1:N) do i
        traps[i] ~ Poisson(mean_traps)
    end

    complaints ~ For(eachindex(traps)) do i
        λ = exp(α + β * traps[i])
        Poisson(λ)
    end
end
