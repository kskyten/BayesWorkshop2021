using Soss: predictive

function posterior_predictive(model, posterior_draws; kwargs...)
    pred = predictive(model, keys(first(posterior_draws))...)(; kwargs...)
    [rand(pred(draw)) for draw in posterior_draws]
end

function posterior_predictive(model::DynamicPPL.Model, posterior_draws; kwargs...)
    predictions = predict(model, posterior_draws)
    return predictions
end
