# Bayes Workshop

## Dependencies

You need to install the R dependencies either through your system R or using
Conda. The Conda installation can be done using the `install_soss_deps` function
in `scripts/install_deps.jl`

## Generating the notebooks

Run `scripts/weave.jl`to generate Jupyter notebooks to `notebooks/{RCall,Soss}`.

## Code

The original Stan code is in `src/stan`. The untested translations are in
`src/{soss,turing}`. The notebook sources are located under `src/weave`.

## Acknowledgement and License

The text in this repository is distributed under the CC BY 4.0 License and code
is distributed under the New BSD License. It is based on the excellent work done
by Lauren Kennedy, Jonah Gabry and Rob Trangucci in https://github.com/jgabry/stancon2018helsinki_intro.
