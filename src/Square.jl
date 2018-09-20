export Square

const SquareSiteType = Tuple{Int, Int}
const SquareEdgeType = Tuple{SquareSiteType, SquareSiteType}

"""
    Square{Shape, BC} <: BoundedLattice{2, BC}

Square lattice.
"""
struct Square{Shape, BC} <: BoundedLattice{2, BC} end

"""
    Square(height, width; [boundary=Periodic])

Returns a square lattice with given `height` and `width`, `boundary` is set to `Periodic`
by default.
"""
Square(height::Int, width::Int; boundary=Periodic) = Square{Tuple{height, width}, boundary}()

size(::Square{Tuple{height, width}}) where {height, width} = (height, width)
length(::Square{Tuple{height, width}}) where {height, width} = height * width
nameof(::Square) = "Square Lattice"

sites(lattice::Square) = SquareSitesIterator(lattice)

struct SquareSitesIterator{Shape}
    SquareSitesIterator(ltc::Square{S}) where S = new{S}()
end

function Base.iterate(it::SquareSitesIterator{Tuple{height, width}}, state = (1, 1, 1)) where {height, width}
    i, j, count = state

    if count == length(it) + 1
        return nothing
    elseif i > height
        return (1, j+1), (2, j+1, count+1)
    else
        return (i, j), (i+1, j, count+1)
    end
end

Base.length(::SquareSitesIterator{Tuple{height, width}}) where {height, width} = width * height
Base.eltype(::SquareSitesIterator) = SquareSiteType

########################

"""
    SquareEdgesIterator{Region, Order, LT}

iterate through `order`-th edge in `Region` on square lattide `LT`.
"""
struct SquareEdgesIterator{Region, Order, LT}
    SquareEdgesIterator{Region, Order}(ltc::LT) where {Region, Order, LT} = new{Region, Order, LT}()
end

Base.eltype(::SquareEdgesIterator) = SquareEdgeType

const FixedSquare{h, w} = Square{Fixed, Tuple{h, w}} where {h, w}
Base.length(::SquareEdgesIterator{:vertical, O, FixedSquare{h, w}}) where {O, h, w} = (h - O) * w
Base.length(::SquareEdgesIterator{:horizontal, O, FixedSquare{h, w}}) where {O, h, w} = (w - O) * h
Base.length(::SquareEdgesIterator{:upright, O, FixedSquare{h, w}}) where {O, h, w} = (w - k) * (h - k)
Base.length(::SquareEdgesIterator{:upleft, O, FixedSquare{h, w}}) where {O, h, w} = (w - k) * (h - k)

function Base.iterate(::SquareEdgesIterator{:vertical, O, FixedSquare{h, w}}) where {O, h, w}
end

function Base.iterate(::SquareEdgesIterator{:horizontal, O, FixedSquare{h, w}}) where {O, h, w}
end

function Base.iterate(::SquareEdgesIterator{:upright, O, FixedSquare{h, w}}) where {O, h, w}
end

function Base.iterate(::SquareEdgesIterator{:upleft, O, FixedSquare{h, w}}) where {O, h, w}
end
