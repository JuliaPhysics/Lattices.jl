module Lattices

import Base: size, ndims, length, show, nameof
using Base.Iterators
using LinearAlgebra

export AbstractLattice, WeightedLattice, CoordinateLattice

export neighbors

export HyperCubic, Chain, Square, SimpleCubic

export AbstractBoundary, PrimitiveBoundary, Periodic, Open, Helical, MixedBoundary

export Coordinate

include("coordinate.jl")
include("boundaries.jl")
include("types.jl")
include("hypercubic.jl")
# include("honeycomb.jl")

end
