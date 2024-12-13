"""
`getdoc(filepath::String; first_head=0)`
read the function descriptions and return a single string ready for `Markdown.parse`.
Now it supports matlab's `.m` function only.

# Example (matlab)
- `y = getdoc("..\\..\\src\\statind.m")` get the docstring (the comments (starts with `% ` eachline) before "function statind(...)").
- `y = getdoc("..\\..\\src\\statind.m", first_head=3)` get the docstring and rearrange all the heading levels based on forcing the first heading level to be 3. That is, take the first heading to be `#` for example, `#` becomes `###` and `##` becomes `####`
- `y = getdoc("..\\..\\src\\statind.m", filename_header=3)` get the docstring and insert a level-3 markdown header at the first line: "### `statind`".
"""
function getdoc(filepath::String; first_head=0, filename_header=0)

    if filename_header > 0
        markdown_header = "% " * join(fill("#", filename_header)) * " `$(split(basename(filepath), ".")[1])`"
    else
        markdown_header = "% "
    end

    s = open(filepath) do file
        readlines(file)
    end
    if splitext(filepath)[end] == ".m" # if it is the matlab file
        doc = _getrawcomment(s)
        insert!(doc, 1, markdown_header)
        y = join(lang_matlab(doc, first_head=first_head))
    else
        y = "<unsupported language>"
    end

    return y
end

"""
`_getrawcomment(s)` get all strings before the line starts with "function" or "classdef";
the comment symbol such as "% " will be kept.
"""
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

    rawcomments = s[1:docend]
end

"""
Given a vector of `rawcomments`, `lang_matlab` strips all comment symbols (i.e., `% `).
"""
function lang_matlab(doc; first_head=0)
    # for Weave.jl, both default or pandoc2html output, mulitiple empty lines == one and results in a linebreak, and linebreak (but no empty line in between) is ignored. So I add linebreaks very generously here.
    br = "\n" # linebreak
    # delete "%" in the beginning of the line.
    doc2 = replace.(doc, r"^%+\s?" => "")

    if first_head != 0 # reformat markdown head levels
        lenhashtags0 = match(r"^#+", doc2[1]).match |> length
        adjust_diff = first_head - lenhashtags0

        ishead = occursin.(r"^#+", doc2[1:end])
        targetid = findall(ishead)
        for i in targetid
            lenhashtags_i = match.(r"^#+", doc2[i]).match |> length
            new_head = "#"^(lenhashtags_i + adjust_diff)
            doc2[i] = replace(doc2[i], r"^#+" => new_head)
        end
    end

    for (i, val) in enumerate(doc2)
        doc2[i] = val * br # add linebreak at the end of every line.
    end

    # codefence = findall(occursin.(r"^(```)",doc2));
    # codestart = codefence[1:2:end];
    # codeend = codefence[2:2:end];

    # numinserted = 0;

    # for id in codefence
    # 	id = id + numinserted;
    # 	# if iseven(numinserted)
    # 	# 	insertat = id; # insert before
    # 	# else
    # 	# 	insertat = id+1;  # insert after
    # 	# end
    # 	insert!(doc2, id, br); # add linebreak before
    # 	insert!(doc2, id+2, br); # add linebreak after
    # 	numinserted = numinserted + 2;
    # end
    return doc2
end
