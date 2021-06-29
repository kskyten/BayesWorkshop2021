using RCall

function install_deps(lib, repo)
reval(
"""
packages <- c(
    'rstan',
    'bayesplot',
    'ggplot2',
    'lubridate',
    'rmarkdown',
    'shinystan',
    'tidyverse'
)
install.packages(packages, lib=$lib, repos=$repo)
""")
end
