"""
    AbstractLattice{N}

Abstract type for general lattices. `N` indicates the dimension.
For a more concrete definition please refer the following material:

- Lattice (group): https://en.wikipedia.org/wiki/Lattice_(group)
- Lattice Model: https://en.wikipedia.org/wiki/Lattice_model_(physics)
- Lattice Graph: https://en.wikipedia.org/wiki/Lattice_graph
"""
abstract type AbstractLattice{N} end
abstract type AbstractUnitCell{N} end

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

abstract type LatticeIterator{L} end
cell(x::LatticeIterator) = cell(x.lattice)
shape(x::LatticeIterator) = shape(x.lattice)
shape(x::LatticeIterator, k) = shape(x.lattice, k)


struct SiteIt{L} <: LatticeIterator{L}
    lattice::L
end

sites(l) = SiteIt(l)
Base.show(io::IO, x::SiteIt) = print(io, "sites(", x.lattice, ")")
SiteType(x) = eltype(sites(x)) # fallback to site iterator by default

struct EdgeIt{L} <: LatticeIterator{L}
    lattice::L
    distance::Int
end

edges(l; distance=1) = EdgeIt(l, distance)
Base.show(io::IO, x::EdgeIt) = print(io, "edges(", x.lattice, ", distance=", x.distance, ")")

struct FaceIt{L} <: LatticeIterator{L}
    lattice::L
end

struct NeighborIt{L} <: LatticeIterator{L}
    lattice::L
    distance::Int
end

# boundary interface
export Periodic, Open
## boundary types are implemented as traits
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
