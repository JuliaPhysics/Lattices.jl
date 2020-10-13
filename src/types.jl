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

unitcellsize(l::AbstractLattice) = 1
hasunitcell(l::AbstractLattice) = Val{false}()

_ncoords(::Val{true}, l::AbstractLattice) = 1 + ndims(l)
_ncoords(::Val{false}, l::AbstractLattice) = ndims(l)
ncoordinates(l::AbstractLattice) = _ncoords(hasunitcell(l), l)

latticeconstants(l::AbstractLattice) = l.lcs
boundaryconditions(l::AbstractLattice) = l.bcs
dimensions(l::AbstractLattice) = l.dims
size(l::AbstractLattice) = dimensions(l)
size(l::AbstractLattice, d::Int) = size(l)[d]

primitivevectors(l::AbstractLattice)
metric(l::AbstractLattice) = (A = primitivevectors(l); A' * A)
ismetricdiag(l::AbstractLattice) = isdiag(metric(l))

==(a::L, b::L) where {L <: AbstractLattice} = false





struct WeightedLattice{L <: AbstractLattice, W} <: AbstractLattice
    lattice::L
    weights::W
end

struct CoordinateLattice{L <: AbstractLattice, Coordinate} <: AbstractLattice
    lattice::L
    coordinates::Vector{Coordinate}
end

struct GraphLattice{Graph} <: AbstractLattice
    graph::Graph
end


# struct HasCoordinate end

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

# struct SitesIt{L}
#     lattice::L
# end

# struct BondsIt{L}
#     lattice::L
#     bond::Int
# end

# function sites end
# function neighbors end
# function bonds end

# Base.iterate(it::BondsIt, st) = iterate_lattice(it, it.lattice, st)
# function iterate_lattice(::BondsIt, lattice, st) end
