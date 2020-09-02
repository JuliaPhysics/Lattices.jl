module Lattices

import Base: size, ndims, length, show, nameof

"""
    AbstractLattice

Abstract type for general lattices.
For a more concrete definition please refer the following material:

- Lattice (group): https://en.wikipedia.org/wiki/Lattice_(group)
- Lattice Model: https://en.wikipedia.org/wiki/Lattice_model_(physics)
- Lattice Graph: https://en.wikipedia.org/wiki/Lattice_graph
"""
abstract type AbstractLattice end

@enum Boundary begin
    Periodict
    Open
    Helical # ignore if not hyperplane like
end

struct HyperPlane{N} <: AbstractLattice
    dims::NTuple{N, Int}
    boundaries::NTuple{N, Boundary}
end

struct WeightedLattice{L <: AbstractLattice, W} <: AbstractLattice
    lattice::L
    weights::W
end

struct CoordinateLattice{L <: AbstractLattice, Position} <: AbstractLattice
    lattice::L
    coordinates::Vector{Position}
end

struct HoneyComb <: AbstractLattice
    dims::NTuple{2, Int}
    boundaries::NTuple{2, Boundary}
end

struct GraphLattice{Graph} <: AbstractLattice
    graph::Graph
end


struct HasCoordinate end

function coordinate(::HoneyComb, id)
end

function coordinate(lattice, id)
end

function coordinate(::HasCoordinate, lattice, id)
end

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

struct BondsIt{L}
    lattice::L
    bond::Int
end

function sites end
function neighbors end
function bonds end

Base.iterate(it::BondsIt, st) = iterate_lattice(it, it.lattice, st)
function iterate_lattice(::BondsIt, lattice, st) end

end