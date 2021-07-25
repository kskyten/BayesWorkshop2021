using Weave
using DrWatson

# for f in readdir(joinpath(@__DIR__, "../src/weave/RCall/"), join=true)
#     weave(f, outpath="../notebooks/RCall")
# end

# for f in readdir(joinpath(@__DIR__, "../src/weave/RCall/"), join=true)
#     notebook(f, outpath="../notebooks/RCall")
# end

nbname(f) = splitext(basename(f))[1] * ".ipynb"

for pkg in ["Turing", "Soss", "RCall"]
    mkpath(projectdir("notebooks", pkg))
    cd(projectdir("notebooks", pkg)) do
        for f in readdir(srcdir("weave", pkg), join=true)
            convert_doc(f, nbname(f))
        end
    end
end

# for pkg in ["RCall", "Soss"]
#     for f in readdir(joinpath(@__DIR__, "../src/weave", pkg), join=true)
#         weave(f, out_path=joinpath(@__DIR__, "../html", pkg))
#     end
# end
