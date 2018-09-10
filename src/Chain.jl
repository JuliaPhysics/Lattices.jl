export Chain, chain

"""
    Chain{L, BC} <: AbstractLattice

Chain lattice. `L` is the length of this chain, and `BC` is the boundary condition.
"""
struct Chain{L, BC <: BoundaryCondition} <: BoundedLattice{1, BC} end

"""
    chain(length; [boundary=Periodic])

Returns a chain lattice with given `length`, the boundary is set to `Periodic`
by default.
"""
chain(len::Int; boundary=Periodic) = Chain{len, boundary}()

size(::Chain{L}) where L = (L, )
length(::Chain{L}) where L = L
name(::Chain) = "Chain Lattice"

# NOTE: OneTo is faster than 1:L
sites(::Chain{L}) where L = Base.OneTo(L)
edges(::Chain{L, BC}; length::Int=1) where {L, BC} = ChainEdgesIterator{L, length, BC}()

struct ChainEdgesIterator{L, order, BC} end

Base.eltype(::ChainEdgesIterator) = Tuple{Int, Int}
Base.length(::ChainEdgesIterator{L, O, Periodic}) where {L, O} = L
Base.length(::ChainEdgesIterator{L, O, Fixed}) where {L, O} = L - O

function Base.iterate(::ChainEdgesIterator{L, O, Fixed}, state=1) where {L, O}
    if state > L - O
        return nothing
    end

    (state, state + O), state + 1
end

function Base.iterate(::ChainEdgesIterator{L, O, Periodic}, state=1) where {L, O}
    if state > L
        return nothing
    end

    (state, (state + O - 1) % L + 1), state + 1
end
