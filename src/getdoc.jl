"""
`getdoc(filepath::String; first_head=0)`
read the function descriptions and return a `Markdown.parse`d object.
Now it supports matlab's `.m` function only.

# Example (matlab)
- `y = getdoc("..\\..\\src\\statind.m")` get all the comments (starts with `% ` eachline) `before function statind(...)`
- `y = getdoc("..\\..\\src\\statind.m", first_head=3)` get all the comments before function section and rearrange all the heading levels based on forcing the first heading level to be 3. That is, take the first heading to be `#` for example, `#` becomes `###` and `##` becomes `####`
"""
function getdoc(filepath::String; first_head=0)


    s = open(filepath) do file
        readlines(file)
    end
    if splitext(filepath)[end] == ".m" # if it is the matlab file
        doc = _getrawcomment(s)
        x = join(lang_matlab(doc, first_head=first_head))
        y = Markdown.parse(x) # or @eval @md_str $x is the same.
    else
        y = Markdown.parse("<unsupported language>")
    end

    return y
end

function _getrawcomment(s)
    funbegin = findfirst(occursin.(r"^(function|classdef)\s", s))
    # find the line where function begin
    if funbegin == 1
        return "No documentation."
    end

    if isnothing(funbegin)
        docend = length(s)
    else
        docend = funbegin - 1
    end

    doc = s[1:docend]
end
