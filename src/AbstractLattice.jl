"""
    AbstractLattice{N}

Abstract type for general lattices. `N` indicates the dimension.
For a more concrete definition please refer the following material:

- Lattice (group): https://en.wikipedia.org/wiki/Lattice_(group)
- Lattice Model: https://en.wikipedia.org/wiki/Lattice_model_(physics)
- Lattice Graph: https://en.wikipedia.org/wiki/Lattice_graph
"""
abstract type AbstractLattice{N} end

"""
    ndims(lattice) -> N

Returns number of dimensions of the lattice.
"""
Base.ndims(::AbstractLattice{N}) where N = N

"""
    size(lattice) -> Tuple

Returns the size of this `lattice`.
"""
function Base.size(::AbstractLattice)
    error("Not Implemented")
end

"""
    name(lattice) -> String

Returns the name of this lattice.
"""
Base.nameof(ltc::AbstractLattice) = "Abstract Lattice"

"""
    length(lattice) -> Int

Returns the length of this lattice, or the production
of each dimension size.
"""
function Base.length(::AbstractLattice)
    error("Not Implemented")
end


abstract type SiteType end
abstract type EdgeType end

EdgeType(::Type{LTC}) where LTC = Tuple{SiteType(LTC), SiteType(LTC)}
