# Bayes Workshop

## Getting started
1. Clone this project.
2. Run `julia --project -e 'using Pkg; Pkg.instantiate()'`
3. Run `julia --project script/weave.jl`
4. At this point all the notebooks should be available in `notebooks`.
5. Finally to install R-dependencies, run `julia --project -e 'include("scripts/install_deps.jl"); install_rcall_deps(); install_soss_deps()'`.

NB: Make sure you're using Julia 1.6.1 or greater. You might need to replace `julia` with `julia-1.6` in the above.

## Dependencies

You need to install the R dependencies either through your system R or using
Conda. The Conda installation can be done using the `install_soss_deps` function
in `scripts/install_deps.jl`

## Generating the notebooks

Run `scripts/weave.jl`to generate Jupyter notebooks to `notebooks/{RCall,Soss,Turing}`.

## Code

The original Stan code is in `src/stan`. The untested translations are in
`src/{soss,turing}`. The notebook sources are located under `src/weave`.

## Acknowledgement and License

The text in this repository is distributed under the CC BY 4.0 License and code
is distributed under the New BSD License. It is based on the excellent work done
by Lauren Kennedy, Jonah Gabry and Rob Trangucci in https://github.com/jgabry/stancon2018helsinki_intro.
