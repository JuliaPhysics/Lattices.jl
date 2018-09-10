export Square, square

"""
    Square{Shape, BC} <: BoundedLattice{2, BC}

Square lattice.
"""
struct Square{Shape, BC} <: BoundedLattice{2, BC} end

"""
    square(height, width; [boundary=Periodic])

Returns a square lattice with given `height` and `width`, `boundary` is set to `Periodic`
by default.
"""
square(height::Int, width::Int; boundary=Periodic) = Square{Tuple{height, width}, boundary}()

size(::Square{Tuple{height, width}}) where {height, width} = (height, width)
length(::Square{Tuple{height, width}}) where {height, width} = height * width
name(::Square) = "Square Lattice"
