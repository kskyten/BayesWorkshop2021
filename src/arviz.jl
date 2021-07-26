using ArviZ, LinearAlgebra

# https://arviz-devs.github.io/ArviZ.jl/stable/quickstart/#Convert-to-InferenceData
function to_arviz(prior_model::Turing.Model, conditioned_model::Turing.Model, posterior_samples::MCMCChains.Chains)
    # Sample from the prior of the latent variables, i.e. everything
    # except `complaints`.
    prior_samples = sample(conditioned_model, Prior(), 1_000, progress=false);
    # Sample "predictions" of `complaints` under `prior_samples`.
    prior_predictive = predict(prior_model, prior_samples);
    # Sample predictions of `complains` under `posterior_samples`.
    posterior_predictive = predict(prior_model, posterior_samples);
    # Compute p(constraints[i] ∣ params...) where `params` are given
    # by samples form `posterior_samples`.
    loglikelihoods = Turing.pointwise_loglikelihoods(
        conditioned_model,
        MCMCChains.get_sections(posterior_samples, :parameters)
    );

    # Ensure the ordering of the loglikelihoods matches the ordering of `posterior_predictive`.
    ynames = string.(keys(posterior_predictive));
    loglikelihoods_vals = getindex.(Ref(loglikelihoods), ynames);
    # Reshape into `(nchains, nsamples, size(y)...)`
    loglikelihoods_arr = permutedims(cat(loglikelihoods_vals...; dims=3), (2, 1, 3));

    # Finally convert into `InferenceData`.
    return from_mcmcchains(
        posterior_samples;
        posterior_predictive=posterior_predictive,
        log_likelihood=Dict("complaints" => loglikelihoods_arr),
        prior=prior_samples,
        prior_predictive=prior_predictive,
        observed_data=Dict("complaints" => conditioned_model.args.complaints),
        library="Turing",
    )
end
