using Markdown: Markdown

# function comment_out(code)
#     "#" * replace(code, "\n" => "\n#")
# end

function convert_to_rcall(code)
    "\n" * "R" * '"'^3  * "\n" * code * "\n" * '"' ^ 3 * "\n"
end

function isrcode(code)
    try
        if code.language == 'r'
            return true
        elseif code.language[2] == 'r'
            return true
        else
            return false
        end
    catch
        return false
    end
end


function weave(ctx, code::Markdown.Code)
   if isrcode(code)
       return Markdown.Code(
           "julia",
           convert_to_rcall(code.code)
       )
   else
       code
   end
end

function weave(ctx, doc::Markdown.MD)
    return Markdown.MD(
        weave.(ctx, doc.content),
        doc.meta
    )
end

weave(ctx, x) = x

function main(ctx, src=joinpath(@__DIR__, "Pest_Control_Example.Rmd"), dst=joinpath(@__DIR__, "notebook.md"))
    parsed = Markdown.parse(read(src, String))
    weaved = string(weave(ctx, parsed))
    __fixed = replace(weaved, r":\$\n\n" => "\$\$\n")
    _fixed = replace(__fixed, r":\$" => "\n\$\$\n")
    fixed = replace(_fixed, r" \$\$" => "\n\$\$\n")
    open(dst, "w") do f
        print(f, fixed)
    end
end
