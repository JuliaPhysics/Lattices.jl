export Triangular

"""
    Triangular{Shape, BC} <: BoundedLattice{2, BC}

Triangular lattices.

Ref: https://en.wikipedia.org/wiki/Hexagonal_lattice
"""
struct Triangular{Shape, BC} <: BoundedLattice{2, BC} end

Triangular(x, y; boundary=Periodic) = Triangular{Tuple{x, y}, boundary}()

nameof(::Triangular) = "Triangular Lattice"
