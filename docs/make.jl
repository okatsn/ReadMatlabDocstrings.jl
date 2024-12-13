using ReadMatlabDocstrings
using Documenter
# using DocumenterCitations
# # 1. Uncomment this line and the CitationBibliography line
# # 2. add docs/src/refs.bib
# # 3. Cite something in refs.bib and add ```@bibliography ``` (in index.md, for example)
# # Please refer https://juliadocs.org/DocumenterCitations.jl/stable/


DocMeta.setdocmeta!(ReadMatlabDocstrings, :DocTestSetup, :(using ReadMatlabDocstrings); recursive=true)

makedocs(;
    modules=[ReadMatlabDocstrings],
    authors="okatsn <okatsn@gmail.com> and contributors",
    repo="https://github.com/okatsn/ReadMatlabDocstrings.jl/blob/{commit}{path}#{line}",
    sitename="ReadMatlabDocstrings.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okatsn.github.io/ReadMatlabDocstrings.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
    # plugins=[
    #     CitationBibliography(joinpath(@__DIR__, "src", "refs.bib")),
    # ],
)

deploydocs(;
    repo="github.com/okatsn/ReadMatlabDocstrings.jl",
    devbranch="main",
)
