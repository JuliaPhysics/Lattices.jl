abstract type AbstractBoundary end
struct Periodic <: AbstractBoundary end
struct Open <: AbstractBoundary end

const SimpleBoundary = Union{Periodic, Open}

# Helical BCs is a fast approximation to
# Periodic BCs that takes advantage of the linear storage of
# arrays. Those familiar with DMRG may recognize this as
# the "snake" boundary condition.
struct Helical <: AbstractBoundary end

# non-mixed BCs
const PrimitiveBoundary = Union{SimpleBoundary, Helical}

# Allows defining lattices with different BCs along each
#  dimension. Does not support Helical BCs as that is a
#  "global" BC.
struct MixedBoundary{N} <: AbstractBoundary
    boundaries::NTuple{N, <:SimpleBoundary}
end
MixedBoundary(bcs::NTuple{N, <:SimpleBoundary}) where N = MixedBoundary{N}(bcs)
MixedBoundary(bcs::NTuple{1, <:SimpleBoundary}) = bcs[1]  # unwraps the passed BC if only 1D