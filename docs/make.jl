using Documenter
using Lattices

makedocs(;
     modules = [Lattices],
     format = Documenter.HTML(),
     sitename = "Lattices",
     pages = Any[
         "Introduction" => "index.md",
     ],
     warnonly = [:cross_references],
)

deploydocs(
     repo = "github.com/JuliaPhysics/Lattices.jl.git",
     target = "build",
     deps = nothing,
     make = nothing
)
