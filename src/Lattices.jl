module Lattices

import Base: size, ndims, length, show, nameof
using Base.Iterators
using LinearAlgebra

export AbstractLattice, WeightedLattice, CoordinateLattice

export neighbors

export HyperCubic, Chain, Square, Cubic

export AbstractBoundary, Periodic, Open, Helical

export Coordinate

include("coordinate.jl")
include("boundaries.jl")
include("types.jl")
include("hypercubic.jl")
# include("honeycomb.jl")

end
