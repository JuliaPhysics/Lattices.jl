"""
    AbstractLattice{N}

Abstract type for general lattices. `N` indicates the dimension.
For a more concrete definition please refer the following material:

- Lattice (group): https://en.wikipedia.org/wiki/Lattice_(group)
- Lattice Model: https://en.wikipedia.org/wiki/Lattice_model_(physics)
- Lattice Graph: https://en.wikipedia.org/wiki/Lattice_graph
"""
abstract type AbstractLattice{N} end

struct SiteIterator{L <: AbstractLattice}
    lattice::L
end

"""
    EdgeIterator{O, L}

Edge iterator for lattice type `L` with order `O`.
"""
struct EdgeIterator{O, L <: AbstractLattice}
    lattice::L
end

"""
    NeighborIterator{O, L}

Neighbor iterator for lattice type `L` with order `O`.
"""
struct NeighborIterator{O, L <: AbstractLattice}
    lattice::L
end

# SiteType/EdgeType are defined as holy traits
abstract type SiteType end
abstract type EdgeType end

EdgeType(::Type{LTC}) where {LTC <: AbstractLattice} = Tuple{SiteType(LTC), SiteType(LTC)}

Base.size(x::AbstractLattice{1}) = (length(x), )
Base.size(x::AbstractLattice, k::Int) = size(x)[k]

export sites, edges, faces, neighbors

# This file defines the interface of a lattice iterator
# All lattice iterators are duck-typed

"""
    sites(lattice) -> iterator

Returns an iterator for all sites on the lattice.
"""
function sites end

"""
    edges(lattice; [order=1]) -> iterator

Returns an iterator for all edges of the lattice of a given `order`.
For example, `order = 1` means nearest neighbor edges and `order = 2`
means next-nearest neighbors edges.
"""
function edges end

"""
    faces(lattice) -> iterator

Returns an iterator of all faces.
"""
function faces end

"""
    neighbors(lattice, s; order=1) -> iterator

Returns an iterator of the surrounding sites of given site `s`.
"""
function neighbors end


# boundary interface
"""
    BoundaryCond

Boundary conditions for lattices. It usually has two:

    - Fixed boundary
    - Periodic boundary

Ref: https://nanohub.org/resources/7577/download/Martini_L5_BoundaryConditions.pdf
"""
abstract type BoundaryCond end

"""
    Periodic <: BoundaryCond

Periodic boundary condition.
"""
struct Periodic <: BoundaryCond end

"""
    Open

Open boundary condition.
"""
struct Open <: BoundaryCond end

"""
    BCUnknown

Boundary Condition is unknown.
"""
struct BCUnknown end

BoundaryCond(::T) where T = BCUnknown()
BoundaryCond(::Type{T}) where T = BCUnknown()

"""
    isperiodic(lattice) -> Bool

Check if this lattice's boundary condition is periodic.
"""
isperiodic(x::AbstractLattice) = isperiodic(BoundaryCond(x))
isperiodic(::Periodic) = true
isperiodic(::Any) = false

"""
    BoundedLattice{N, BC} <: AbstractLattice{N}

A lattice with boundary conditions `BC` on `N` dimension.
"""
abstract type BoundedLattice{N, BC <: BoundaryCond} <: AbstractLattice{N} end

BoundaryCond(::BoundedLattice{N, BC}) where {N, BC} = BC()
