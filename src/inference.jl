using Soss

model(x) = x.model

struct Options
    nchains :: Int
    nsamples :: Union{Int, Float64}
end

const DEFAULT_OPTIONS = Options(4, 1000)

nchains(x) = x.nchains
nsamples(x) = x.nsamples

struct PriorPredictive
    options
    model
end

struct StreamingPriorPredictive
    options
    model
end

function prior_predictive(model; options = DEFAULT_OPTIONS)
        map(1:nchains(options) * nsamples(options)) do _
        draw = rand(model)
        return delete(draw, arguments(model))
    end
end

struct Posterior
    options
    model
end

struct StreamingPosterior
    options
    model
end

function posterior(model, data; options = DEFAULT_OPTIONS)
    sample(model, data, sampler(model, options), options)
end

function sample(model, data, sampler, options)
    post = map(1:nchains(options)) do _
        sampler(model, data, nsamples(options))
    end
end

struct PosteriorPredictive
    options
    model
    posterior_samples
end

struct StreamingPosteriorPredictive
    options
    model
end

using NamedTupleTools

function constant_args(joint_distribution, predictive_distribution)
    # intersecting_keys = intersect(arguments(predictive_distribution),
    #                               keys(arguments(joint_distribution)))
    delete(arguments(joint_distribution),
           setdiff(keys(arguments(joint_distribution)),
                   arguments(predictive_distribution))...)
end


# function posterior_predictive(joint_distribution, data, _posterior_samples; options = DEFAULT_OPTIONS)
#     mdl = model(joint_distribution)
#     latent_variables = setdiff(parameters(mdl), keys(data))
#     pred = predictive(mdl, latent_variables...)
#     posterior_samples = (convert(NamedTuple, x) for x in eachrow(_posterior_samples))
#     constant_arguments = constant_args(joint_distribution, pred)
#     post_postpred = map(posterior_samples) do post_draws
#         map(post_draws) do post_draw
#             args = merge(post_draw, constant_arguments)
#             pred_draw = rand(pred(args))
#             pred_draw = delete(pred_draw, arguments(mdl))
#             return merge(pred_draw, post_draw)
#         end
#     end
# end
#

Principled Bayesian workflow and composable diagnostics

Here is a sketch of model transformations for principled Bayesian workflow (see: https://betanalpha.github.io/assets/case_studies/principled_bayesian_workflow.html). Currently these work only for the output from DynamicHMC. Like I mentioned in the probprog channel, there doesn't seem to be a Julia PPL package that achieves quite the workflow I'm after. I like the use of named tuples in DynamicHMC for sampler outputs. It can also be made easily compatible with TableTraits. The output from AdvancedHMC is not composable with the inputs of a Soss model, so the posterior predictive function won't work. Currently, the bayesplot R package (https://mc-stan.org/bayesplot/index.html) has the best diagnostic plots for Bayesian data analysis that I'm aware of. It can easily be used through RCall with a simple transformation of AdvancedHMC's output. Further down the line, it would be really cool to use something like https://github.com/tkf/VegaStreams.jl to make the diagnostic plots live. How do I make streaming versions of the transformations below?

```julia
using Soss
using NamedTupleTools

model(x) = x.model

struct Options
    nchains :: Int
    nsamples :: Union{Int, Float64}
end

const DEFAULT_OPTIONS = Options(4, 1000)

nchains(x) = x.nchains
nsamples(x) = x.nsamples

"""
Draw samples from the prior predictive distribution.

# Arguments:
  - joint: the joint probability distribution (ie. a Soss model where all the parameters are bound)
"""
function prior_predictive(joint; options = DEFAULT_OPTIONS)
        map(1:nchains(options) * nsamples(options)) do _
        draw = rand(joint)
        return delete(draw, arguments(joint))
    end
end

"""
Draw samples from the posterior predictive distribution.

# Arguments:
  - joint: the joint probability distribution (ie. a Soss model where all the parameters are bound)
  - data: a named tuple of observations
  - posterior: samples from the posterior as vector of named tuples (DynamicHMC output)
"""
function posterior_predictive(joint, data, posterior)
    mdl = model(joint)
    bound_arguments = arguments(joint)

    latent_variables = setdiff(parameters(mdl), keys(data))

    pred = predictive(mdl, latent_variables...)
    pred_args = arguments(pred)
    const_keys = intersect(pred_args, keys(bound_arguments))
    const_args = NamedTupleTools.select(bound_arguments, const_keys)
    draws = []
    for posterior_draw in posterior
        predargs = merge(const_args, posterior_draw)
        pred_draw = rand(pred(predargs))
        pd1 = delete(pred_draw, const_keys...)
        posterior_pred_draw = merge(pd1, posterior_draw)
        push!(draws, posterior_pred_draw)
    end
    return draws
end
```

# function posterior_predictive(model, data; options = DEFAULT_OPTIONS)
#     posterior_samples = sample(model, data, )
# end
