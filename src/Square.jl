export Square

const SquareSiteType = Tuple{Int, Int}
const SquareEdgeType = Tuple{SquareSiteType, SquareSiteType}

"""
    Square{Shape, BC} <: BoundedLattice{2, BC}

Square lattice.
"""
struct Square{Shape, BC <: BoundaryCondition} <: BoundedLattice{2, BC} end

"""
    Square(height, width; [boundary=Periodic])

Returns a square lattice with given `height` and `width`, `boundary` is set to `Periodic`
by default.
"""
Square(height::Int, width::Int; boundary=Periodic) = Square{Tuple{height, width}, boundary}()

Base.size(::Square{Tuple{height, width}}) where {height, width} = (height, width)
Base.length(::Square{Tuple{height, width}}) where {height, width} = height * width
Base.nameof(::Square) = "Square Lattice"

sites(lattice::Square) = SquareSitesIterator(lattice)

function edges(lattice::Square; length::Int=1)
    if isodd(length)
        k = (length + 1) ÷ 2
        SquareFusedEdgesIterator(
            SquareEdgesIterator{:vertical, k}(lattice),
            SquareEdgesIterator{:horizontal, k}(lattice)
        )
    else
        k = length ÷ 2
        SquareFusedEdgesIterator(
            SquareEdgesIterator{:upright, k}(lattice),
            SquareEdgesIterator{:upleft, k}(lattice)
        )
    end
end

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

struct SquareFusedEdgesIterator{T <: Tuple}
    its::T
end

SquareFusedEdgesIterator(its...) = SquareFusedEdgesIterator(its)

Base.eltype(::SquareFusedEdgesIterator) = SquareEdgeType
Base.length(it::SquareFusedEdgesIterator) = sum(length, it.its)

function Base.iterate(it::SquareFusedEdgesIterator, state=((1, 1, 1), 1))
    it_state, nit = state
    if nit > length(it.its)
        return nothing
    end

    it_result = iterate(it.its[nit], it_state)

    if it_result !== nothing
        result, it_state = it_result
        return result, (it_state, nit)
    end

    if nit + 1 > length(it.its)
        return nothing
    end

    it_result = iterate(it.its[nit+1], (1, 1, 1))
    if it_result !== nothing
        result, it_state = it_result
        return result, (it_state, nit+1)
    end

    nothing
end

function Base.show(io::IO, it::SquareFusedEdgesIterator)
    println(io, "Fused SquareEdgesIterator:")
    for each in it.its
        if each === last(it.its)
            print(io, "  ", each)
        else
            println(io, "  ", each)
        end
    end
end

"""
    SquareEdgesIterator{Region, Order, LT}

iterate through `order`-th edge in `Region` on square lattide `LT`.
"""
struct SquareEdgesIterator{Region, Order, LT}
    SquareEdgesIterator{Region, Order}(ltc::LT) where {Region, Order, LT} = new{Region, Order, LT}()
end

Base.eltype(::SquareEdgesIterator) = SquareEdgeType

const FixedSquare{h, w} = Square{Tuple{h, w}, Fixed} where {h, w}
Base.length(::SquareEdgesIterator{:vertical, K, FixedSquare{h, w}}) where {K, h, w} = (h - K) * w
Base.length(::SquareEdgesIterator{:horizontal, K, FixedSquare{h, w}}) where {K, h, w} = (w - K) * h
Base.length(::SquareEdgesIterator{:upright, K, FixedSquare{h, w}}) where {K, h, w} = (w - k) * (h - k)
Base.length(::SquareEdgesIterator{:upleft, K, FixedSquare{h, w}}) where {K, h, w} = (w - k) * (h - k)

function Base.iterate(it::SquareEdgesIterator{:vertical, K, FixedSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i + K > h
        return ((1, j+1), (1+K, j+1)), (2, j+1, count + 1)
    else
        ((i, j), (i+K, j)), (i+1, j, count+1)
    end
end

function Base.iterate(it::SquareEdgesIterator{:horizontal, K, FixedSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i > h
        return ((1, j+1), (1, j+K+1)), (2, j+1, count + 1)
    else
        ((i, j), (i, j+K)), (i+1, j, count+1)
    end
end

function Base.iterate(it::SquareEdgesIterator{:upright, K, FixedSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i+K > h
        return ((1, j+1), (1+K, j+K+1)), (2, j+1, count+1)
    else
        ((i, j), (i+K, j+K)), (i+1, j, count+1)
    end
end

function Base.iterate(it::SquareEdgesIterator{:upleft, K, FixedSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i+K > h
        return ((1+K, j+1), (1, j+K+1)), (2, j+1, count+1)
    else
        ((i+K, j), (i, j+K)), (i+1, j, count+1)
    end
end

#####################
const PeriodicSquare{h, w} = Square{Tuple{h, w}, Periodic} where {h, w}
Base.length(::SquareEdgesIterator{R, K, PeriodicSquare{h, w}}) where {R, K, h, w} = h * w

function Base.iterate(it::SquareEdgesIterator{:vertical, K, PeriodicSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i > h
        return ((1, j+1), (K % h + 1, j+1)), (2, j+1, count+1)
    else
        ((i, j), ((i+K-1)%h+1, j)), (i+1, j, count+1)
    end
end

function Base.iterate(it::SquareEdgesIterator{:horizontal, K, PeriodicSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i > h
        return ((1, j+1), (1, (j+K)%w+1)), (2, j+1, count+1)
    else
        ((i, j), (i, (j+K-1)%w+1)), (i+1, j, count+1)
    end
end

function Base.iterate(it::SquareEdgesIterator{:upright, K, PeriodicSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i < h
        return ((1, j+1), (K%h+1, (j+K)%w+1)), (2, j+1, count+1)
    else
        ((i, j), (i+K-1)%h+1, (j+K-1)%w+1), (i+1, j, count+1)
    end
end

function Base.iterate(it::SquareEdgesIterator{:upleft, K, PeriodicSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
    elseif i < h
        return ((K%h+1, j+1), (1, (j+K)%w+1)), (2, j+1, count+1)
    else
        (((i+K-1)%h+1, j), (i, (j+K-1)%w+1)), (i+1, j, count+1)
    end
end

Base.getindex(lattice::Square, inds::Int...) = getindex(lattice, inds)
Base.getindex(lattice::FixedSquare{h, w}, inds::NTuple{2, Int}) where h where w =
    inds[1] > h ? throw(BoundsError(lattice, inds)) :
    inds[2] > w ? throw(BoundsError(lattice, inds)) :
    inds[1] + (inds[2] - 1) * h
Base.getindex(lattice::PeriodicSquare{h, w}, inds::NTuple{2, Int}) where h where w =
    mod1(inds[1], h) + mod(inds[2] - 1, w) * h

(ltc::FixedSquare{h, w})(s::Int) where {h, w} =
    s > length(ltc) || s < 1 ? throw(BoundsError(ltc, s)) :
    mod1(s, h), div(s - 1, h) + 1

(ltc::PeriodicSquare{h, w})(s::Int) where {h, w} =
    mod1(s, h), div(s - 1, h) + 1
