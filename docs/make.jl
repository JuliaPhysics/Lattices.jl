using Documenter, Lattices

makedocs(
     modules = [Lattices],
     format  = :html,
     sitename = "Lattices",
     pages = Any[
         "Introduction"   => "index.md"
     ],
     # Use clean URLs, unless built as a "local" build
     html_prettyurls = !("local" in ARGS),
     # html_canonical = "https://juliadocs.github.io/Documenter.jl/latest/",
)

deploydocs(
     repo = "github.com:Roger-luo/Lattices.jl.git",
     target = "build",
     julia = "1.0",
     osname = "osx",
     deps = nothing,
     make = nothing
)
