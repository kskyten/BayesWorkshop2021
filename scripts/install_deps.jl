# https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started

using Pkg
using Conda
Conda.add_channel("conda-forge")
Conda.add_channel("r")

function install_soss_deps()
    Conda.add("r", channel="r")
    Conda.add("r-bayesplot")
    Conda.add("r-ggplot2")
    ENV["R_HOME"] = joinpath(Conda.LIBDIR, "R")
    Pkg.build("RCall")
end

function install_rcall_deps()
    install_soss_deps()
    Conda.add("r-lubridate")
    Conda.add("r-rmarkdown")
    Conda.add("r-shinystan")
    Conda.add("r-tidyverse")
    Conda.add("r-rstan")
end
