using Soss

multiple_poisson_regression = @model (traps, live_in_super, log_sq_foot) begin
    beta ∼ Normal(-0.25, 1)
    beta_super ∼ Normal(-0.5, 1)
    alpha ∼ Normal(log(4), 1)

    complaints ∼ For(eachindex(traps)) do i
        # TODO: Numerically safe version
        λ = exp(alpha + beta * traps[i] + beta_super * live_in_super[i] + log_sq_foot[i])
        Poisson(λ)
    end
end
