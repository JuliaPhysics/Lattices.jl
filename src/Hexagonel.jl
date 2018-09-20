export Hexagonel

"""
    Hexagonel{Shape, BC} <: BoundedLattice{2, BC}

Hexagonel lattice.

Ref: https://en.wikipedia.org/wiki/Hexagonal_lattice
"""
struct Hexagonel{Shape <: Tuple, BC} <: BoundedLattice{2, BC} end

Hexagonel(x, y; boundary=Periodic) = Hexagonel{Tuple{x, y}, boundary}()
nameof(::Hexagonel) = "Hexagonel Lattice"
