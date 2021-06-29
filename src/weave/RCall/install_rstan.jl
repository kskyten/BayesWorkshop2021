# https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started

using Conda
Conda.add_channel("conda-forge")
Conda.add_channel("r")
Conda.add("r", channel="r")
Conda.add("r-bayesplot")
Conda.add("r-ggplot2")
Conda.add("r-lubridate")
Conda.add("r-rmarkdown")
Conda.add("r-shinystan")
Conda.add("r-tidyverse")
Conda.add("r-rstan")

using Pkg
ENV["R_HOME"] = joinpath(Conda.LIBDIR, "R")
Pkg.add("RCall")
