@reexport module ChainLattice
export Chain

using Lattices: BoundaryCondition, BoundedLattice, Fixed, Periodic
import Lattices

"""
    Chain{L, BC} <: AbstractLattice

Chain lattice. `L` is the length of this chain, and `BC` is the boundary condition.
"""
struct Chain{L, BC <: BoundaryCondition} <: BoundedLattice{1, BC} end

"""
    Chain(length; [boundary=Periodic])

Returns a chain lattice with given `length`, the boundary is set to `Periodic`
by default.
"""
Chain(len::Int; boundary=Periodic) = Chain{len, boundary}()

Base.size(::Chain{L}) where L = (L, )
Base.length(::Chain{L}) where L = L
Base.nameof(::Chain) = "Chain Lattice"

# NOTE: OneTo is faster than 1:L
Lattices.sites(::Chain{L}) where L = Base.OneTo(L)
Lattices.edges(::Chain{L, BC}; length::Int=1) where {L, BC} = EdgesIterator{L, length, BC}()

struct EdgesIterator{L, order, BC} end

Base.size(it::EdgesIterator) = (length(it), )
Base.eltype(::EdgesIterator) = Tuple{Int, Int}
Base.length(::EdgesIterator{L, O, Periodic}) where {L, O} = L
Base.length(::EdgesIterator{L, O, Fixed}) where {L, O} = L - O

function Base.iterate(::EdgesIterator{L, O, Fixed}, state=1) where {L, O}
    if state > L - O
        return nothing
    end

    (state, state + O), state + 1
end

function Base.iterate(::EdgesIterator{L, O, Periodic}, state=1) where {L, O}
    if state > L
        return nothing
    end

    (state, mod1(state + O, L)), state + 1
end

Base.getindex(ltc::Chain, inds::Tuple{Int}) = Base.getindex(ltc, first(inds))

Base.getindex(ltc::Chain{L, Fixed}, x::Int) where L = 1 <= x <= L ? x : throw(BoundsError(ltc, x))
Base.getindex(ltc::Chain{L, Periodic}, x::Int) where L = mod1(x, L)

(ltc::Chain{L, Fixed})(x::Int) where L = 1 <= x <= L ? x : throw(BoundsError(ltc, x))
(ltc::Chain{L, Periodic})(x::Int) where L = mod1(x, L)

end
