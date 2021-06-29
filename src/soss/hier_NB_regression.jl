using Soss

hier_NB_regression = @model (traps, live_in_super, log_sq_foot) begin
    # alpha ∼ Normal(log(4), 1)
    # beta ∼ Normal(-0.25, 1)
    # beta_super ∼ Normal(-0.5, 1)
    # inv_phi ∼ Normal(0, 1)

    # complaints ∼ For(eachindex(traps)) do i
    #     # TODO: Log parametrization
    #     r = exp(alpha + beta * traps[i] + beta_super * live_in_super[i] + log_sq_foot[i])
    #     p = inv(inv_phi)
    #     # NegativeBinomial(r, p)
    # end
end
