export BoundedLattice, boundary, isperiodic

"""
    BoundedLattice{N, BC} <: AbstractLattice{N}

A lattice with boundary conditions `BC` on `N` dimension.
"""
abstract type BoundedLattice{N, BC <: BoundaryCondition} <: AbstractLattice{N} end


# Bounded Lattice Traits
"""
    boundary(lattice) -> BoundaryCondition

Returns lattice's boundary condition.
"""
function boundary end

"""
    isperiodic(lattice) -> Bool

Check if this lattice's boundary condition is periodic.
"""
function isperiodic end

boundary(::Type{<:BoundedLattice{N, BC}}) where {N, BC} = BC

isperiodic(::Type{<:BoundedLattice{N, Periodic}}) where N = true
isperiodic(::Type{<:BoundedLattice}) = false

# forward instance traits
isperiodic(::T) where {T <: BoundedLattice} = isperiodic(T)
boundary(::T) where {T <: BoundedLattice} = boundary(T)

show(io::IO, lattice::BoundedLattice) = print(io, "$(name(lattice)):\n  $(boundary(lattice)) boundary\n  size: $(size(lattice))")
