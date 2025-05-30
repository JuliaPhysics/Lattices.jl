"""
$(TYPEDEF)

Abstract supertype for all boundary conditions.
"""
abstract type AbstractBoundary end

"""
$(TYPEDEF)

Periodic boundary condition.
"""
struct Periodic <: AbstractBoundary end
struct Open <: AbstractBoundary end

# Helical BCs is a fast approximation to
# Periodic BCs that takes advantage of the linear storage of
# arrays. Those familiar with DMRG may recognize this as
# the "snake" boundary condition.
struct Helical <: AbstractBoundary end


# no checks necessary if all BCs are the same type
for B in [:Periodic, :Open, :Helical]
    @eval check_boundaries(bcs::NTuple{N, $B}) where N = bcs
end
function check_boundaries(bcs::NTuple{N, AbstractBoundary}) where N
    if any(x -> x isa Helical, bcs)
        throw(ArgumentError("Can't combine Helical boundary conditions with other BCs!"))
    end
    return bcs
end
check_boundaries(bcs::AbstractBoundary...) = check_boundaries(bcs)


apply_boundary(::Periodic, length::Int, x::Int) = mod(x, 1:length)
apply_boundary(::Open, length::Int, x::Int) = (1 <= x <= length) ? x : nothing
