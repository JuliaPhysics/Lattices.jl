abstract type AbstractBoundary end
struct Periodic <: AbstractBoundary end
struct Open <: AbstractBoundary end

# Helical BCs is a fast approximation to
# Periodic BCs that takes advantage of the linear storage of
# arrays. Those familiar with DMRG may recognize this as
# the "snake" boundary condition.
struct Helical <: AbstractBoundary end

# non-mixed BCs
const PrimitiveBoundary = Union{Periodic, Helical, Open}

# Allows defining lattices with different BCs along each
#  dimension. Should reject Helical BC as that is a "global" BC.
struct MixedBoundary{N} <: AbstractBoundary
    boundaries::NTuple{N, AbstractBoundary}
    function MixedBoundary{N}(bcs::NTuple{N, AbstractBoundary}) where N
        if any(x -> x isa Helical, bcs)
            throw(ArgumentError("Can't construct a MixedBoundary with a Helical boundary!"))
        elseif any(x -> x isa MixedBoundary, bcs)
            throw(ArgumentError("Can't nest MixedBoundary structs!"))
        end
        new{N}(bcs)
    end
end

# return the BC if there's only one
MixedBoundary(bcs::NTuple{N, Periodic}) where N = Periodic()
MixedBoundary(bcs::NTuple{N, Open}) where N = Open()
MixedBoundary(bcs::NTuple{N, Helical}) where N = Helical()

# base case for no type params
MixedBoundary(bcs::NTuple{N, AbstractBoundary}) where N = MixedBoundary{N}(bcs)


MixedBoundary(bcs::Vector{AbstractBoundary}) = MixedBoundary(tuple(bcs...))
MixedBoundary(bcs::AbstractBoundary...) = MixedBoundary(bcs)