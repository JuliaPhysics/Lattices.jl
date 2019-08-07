module Lattices

using Reexport

include("utils.jl")

include("BoundaryConditions.jl")

# Interface
include("base.jl")

include("chain2.jl")

# Implementations
# include("Chain.jl")
# include("square/Square.jl")
# include("hyperrect.jl")

end # module
