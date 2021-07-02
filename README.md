# Bayes Workshop

The original Stan code is in `src/stan`. The untested translations are in
`src/{soss,turing}`. The original workshop in R can be run with `RCall` and is
located in `src/weave/RCall`. You need to install the R dependencies first
with `scripts/install_rstan.jl`. The sources for the Soss notebooks are in
`src/weave/Soss`. The script `scripts/weave.jl` converts the Weave notebooks to
Jupyter notebooks.

## Acknowledgement and License

The text in this repository is distributed under the CC BY 4.0 License and code
is distributed under the New BSD License. It is based on the excellent work done
by Lauren Kennedy, Jonah Gabry and Rob Trangucci in https://github.com/jgabry/stancon2018helsinki_intro.
