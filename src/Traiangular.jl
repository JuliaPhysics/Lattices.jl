export Triangular, triangular

"""
    Triangular{Shape, BC} <: BoundedLattice{2, BC}

Triangular lattices.

Ref: https://en.wikipedia.org/wiki/Hexagonal_lattice
"""
struct Triangular{Shape, BC} <: BoundedLattice{2, BC} end

triangular(x, y; boundary=Periodic) = Triangular{Tuple{x, y}, boundary}()
