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
Lattices.edges(::Chain{L, BC}; order::Int=1) where {L, BC} = EdgesIterator{L, order, BC}()

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

(ltc::Chain{L, B})(x::Int) where {L,B} = getindex(ltc, x)

Lattices.neighbors(ltc::Chain{L, Periodic}, s::Int; order=1) where L = (ltc(s+order), ltc(s-order))

# OPT: Can we do something about the type instability here?
function Lattices.neighbors(ltc::Chain{L, Fixed}, s::Int; order=1) where L
    sp, sm = s+order, s-order
    if sp > L && sm < 1
        return (nothing, nothing)
    elseif sp > L && sm >= 1
        return (nothing, sm)
    elseif sp <= L && sm < 1
        return (sp, nothing)
    else
        return (sp, sm)
    end
end

end
