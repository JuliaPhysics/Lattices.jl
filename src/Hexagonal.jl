export Hexagonal

"""
    Hexagonal{Shape, BC} <: BoundedLattice{2, BC}

Hexagonal lattice.

Ref: https://en.wikipedia.org/wiki/Hexagonal_lattice
"""
struct Hexagonal{Shape <: Tuple, BC} <: BoundedLattice{2, BC} end

Hexagonal(x, y; boundary=Periodic) = Hexagonal{Tuple{x, y}, boundary}()
nameof(::Hexagonal) = "Hexagonal Lattice"
