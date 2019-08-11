"""
    Chain{L, BC} <: AbstractLattice

Chain lattice. `L` is the length of this chain, and `BC` is the boundary condition.
"""
struct Chain{BC, L} <: BoundedLattice{1, BC} end

"""
    Chain{[T=Periodic]}(length)

Returns a chain lattice with given `length`, the boundary is set to `Periodic`
by default.
"""
Chain(len::Int) = Chain{Periodic}(len)
Chain{BC}(len::Int) where BC = Chain{BC, len}()

Base.length(::Chain{L}) where L = L
SiteType(::Chain) = Int

Lattices.sites(::Chain{L}) where L = Base.OneTo(L)