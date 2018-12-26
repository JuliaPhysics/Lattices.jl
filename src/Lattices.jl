module Lattices

using Reexport

include("utils.jl")

include("BoundaryConditions.jl")

# Basic Interface
include("AbstractLattice.jl")
include("BoundedLattice.jl")

# Lattice Iterator Interface
include("LatticeIterators.jl")

# Implementations
include("Chain.jl")
include("square/Square.jl")
include("hyperrect.jl")

end # module
