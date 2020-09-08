module Lattices

import Base: size, ndims, length, show, nameof
using Base.Iterators

using StaticArrays

export AbstractLattice, AbstractCoordinateLattice,
        WeightedLattice, CoordinateLattice

export HyperCubic, Chain, Square, SimpleCubic

export AbstractBoundary, Periodic, Open, Helical, MixedBoundary


export Coordinate

include("coordinate.jl")
include("types.jl")
"""
- Lattice (group): https://en.wikipedia.org/wiki/Lattice_(group)
- Lattice Model: https://en.wikipedia.org/wiki/Lattice_model_(physics)
- Lattice Graph: https://en.wikipedia.org/wiki/Lattice_graph
"""
abstract type AbstractLattice{N} end
abstract type AbstractCoordinateLattice{N} <: AbstractLattice{N} end
ndims(::AbstractLattice{N}) where N = N




struct WeightedLattice{N, L, W} <: AbstractLattice{N}
    lattice::L
    weights::W
end

struct CoordinateLattice{N, L, Position} <: AbstractCoordinateLattice{N}
    lattice::L
    coordinates::Vector{Position}
end

# struct GraphLattice{Graph} <: AbstractLattice
#     graph::Graph
# end

# function coordinate(::HoneyComb, id)
# end

# function coordinate(lattice, id)
# end

# function coordinate(::HasCoordinate, lattice, id)
# end

# for (i, j) in edges(lattice; bond=k)
# end

# # <=>
# for i in sites(lattice)
#     for j in neighbors(lattice, i, k)
#         if i < j
#             value = get_term(H, i, j)
#         end
#     end
# end

struct SitesIt{L}
    lattice::L
end

struct EdgesIt{L, B}
    lattice::L
end



sites(lattice::L) where L <: AbstractLattice = SitesIt{L}(lattice)


# neighbors(lattice::AbstractLattice{N}, site::NTuple{N, Int}, k::Val{K}) where {N, K}
neighbors(lattice, site) = neighbors(lattice, site, Val{1})

# function coordinate(lattice, id) end

# function Base.iterate(it::EdgesIt, st=(sites(it.lattice),))


# end



include("boundaries.jl")
include("hypercubic.jl")
include("honeycomb.jl")

end #module
