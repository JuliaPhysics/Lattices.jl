export Square

using Lattices: BoundaryCondition, Fixed, Periodic, BoundedLattice

"""
    Square{Shape, BC} <: BoundedLattice{2, BC}

Square lattice.
"""
struct Square{Shape, BC <: BoundaryCondition} <: BoundedLattice{2, BC} end

# alias
const FixedSquare{h, w} = Square{Tuple{h, w}, Fixed} where {h, w}
const PeriodicSquare{h, w} = Square{Tuple{h, w}, Periodic} where {h, w}

# traits
SiteType(::Type{Square}) = Tuple{Int, Int}


"""
    Square(height, width; [boundary=Periodic])

Returns a square lattice with given `height` and `width`, `boundary` is set to `Periodic`
by default.
"""
Square(height::Int, width::Int; boundary=Periodic) = Square{Tuple{height, width}, boundary}()

Base.size(::Square{Tuple{height, width}}) where {height, width} = (height, width)
Base.length(::Square{Tuple{height, width}}) where {height, width} = height * width
Base.nameof(::Square) = "Square Lattice"

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

# iterators
## sites iterators
sites(lattice::Square) = SitesIterator(lattice)

struct SitesIterator{Shape}
    SitesIterator(ltc::Square{S}) where S = new{S}()
end

function Base.iterate(it::SitesIterator{Tuple{height, width}}, state = (1, 1, 1)) where {height, width}
    i, j, count = state

    if count == length(it) + 1
        return nothing
    elseif i > height
        return (1, j+1), (2, j+1, count+1)
    else
        return (i, j), (i+1, j, count+1)
    end
end

Base.size(::SitesIterator{Tuple{H, W}}) where {H, W} = (H, W)
Base.length(::SitesIterator{Tuple{height, width}}) where {height, width} = width * height
Base.eltype(::SitesIterator) = SiteType

## edges iterators
function edges(lattice::Square; order::Int=1)
    if isodd(order)
        k = (order + 1) ÷ 2
        FusedEdgesIterator(
            EdgesIterator{:vertical, k}(lattice),
            EdgesIterator{:horizontal, k}(lattice)
        )
    else
        k = order ÷ 2
        FusedEdgesIterator(
            EdgesIterator{:upright, k}(lattice),
            EdgesIterator{:upleft, k}(lattice)
        )
    end
end

struct FusedEdgesIterator{T <: Tuple}
    its::T
end

FusedEdgesIterator(its...) = FusedEdgesIterator(its)
Base.size(it::FusedEdgesIterator) = map(length, it.its)

Base.eltype(::FusedEdgesIterator) = EdgeType
Base.length(it::FusedEdgesIterator) = sum(length, it.its)

# Generates the coupling
Base.rand(::Type{T}, it::FusedEdgesIterator) where T = rand(T, size(it))
Base.rand(it::FusedEdgesIterator) = rand(Float64, it)

function Base.iterate(it::FusedEdgesIterator, state=((1, 1, 1), 1))
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

function Base.show(io::IO, it::FusedEdgesIterator)
    println(io, "Fused EdgesIterator:")
    for each in it.its
        if each === last(it.its)
            print(io, "  ", each)
        else
            println(io, "  ", each)
        end
    end
end

"""
    EdgesIterator{Region, Order, LT}

iterate through `order`-th edge in `Region` on square lattide `LT`.
"""
struct EdgesIterator{Region, Order, LT}
    EdgesIterator{Region, Order}(ltc::LT) where {Region, Order, LT} = new{Region, Order, LT}()
end

Base.eltype(::EdgesIterator) = EdgeType

Base.length(::EdgesIterator{:vertical, K, FixedSquare{h, w}}) where {K, h, w} = (h - K) * w
Base.length(::EdgesIterator{:horizontal, K, FixedSquare{h, w}}) where {K, h, w} = (w - K) * h
Base.length(::EdgesIterator{:upright, K, FixedSquare{h, w}}) where {K, h, w} = (w - k) * (h - k)
Base.length(::EdgesIterator{:upleft, K, FixedSquare{h, w}}) where {K, h, w} = (w - k) * (h - k)

function Base.iterate(it::EdgesIterator{:vertical, K, FixedSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i + K > h
        return ((1, j+1), (1+K, j+1)), (2, j+1, count + 1)
    else
        ((i, j), (i+K, j)), (i+1, j, count+1)
    end
end

function Base.iterate(it::EdgesIterator{:horizontal, K, FixedSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i > h
        return ((1, j+1), (1, j+K+1)), (2, j+1, count + 1)
    else
        ((i, j), (i, j+K)), (i+1, j, count+1)
    end
end

function Base.iterate(it::EdgesIterator{:upright, K, FixedSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i+K > h
        return ((1, j+1), (1+K, j+K+1)), (2, j+1, count+1)
    else
        ((i, j), (i+K, j+K)), (i+1, j, count+1)
    end
end

function Base.iterate(it::EdgesIterator{:upleft, K, FixedSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
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
Base.length(::EdgesIterator{R, K, PeriodicSquare{h, w}}) where {R, K, h, w} = h * w

function Base.iterate(it::EdgesIterator{:vertical, K, PeriodicSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i > h
        return ((1, j+1), (K % h + 1, j+1)), (2, j+1, count+1)
    else
        ((i, j), ((i+K-1)%h+1, j)), (i+1, j, count+1)
    end
end

function Base.iterate(it::EdgesIterator{:horizontal, K, PeriodicSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i > h
        return ((1, j+1), (1, (j+K)%w+1)), (2, j+1, count+1)
    else
        ((i, j), (i, (j+K-1)%w+1)), (i+1, j, count+1)
    end
end

function Base.iterate(it::EdgesIterator{:upright, K, PeriodicSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
        return nothing
    elseif i < h
        return ((1, j+1), (K%h+1, (j+K)%w+1)), (2, j+1, count+1)
    else
        ((i, j), (i+K-1)%h+1, (j+K-1)%w+1), (i+1, j, count+1)
    end
end

function Base.iterate(it::EdgesIterator{:upleft, K, PeriodicSquare{h, w}}, state = (1, 1, 1)) where {K, h, w}
    i, j, count = state
    if count > length(it)
    elseif i < h
        return ((K%h+1, j+1), (1, (j+K)%w+1)), (2, j+1, count+1)
    else
        (((i+K-1)%h+1, j), (i, (j+K-1)%w+1)), (i+1, j, count+1)
    end
end


## neighbors iterators
struct NeighborSiteIterator{Shape, BC, K}
    site::Tuple{Int, Int}
end

neighbors(lattice::Square{S, BC}, site; order::Int=1) where {S, BC} = NeighborSiteIterator{S, BC, order}(site)
Base.eltype(::NeighborSiteIterator) = SiteType
Base.length(::NeighborSiteIterator{<:Tuple, Periodic}) = 4

function _iterate_odd(it::NeighborSiteIterator{Tuple{h, w}, Periodic}, K, state) where {h, w}
    x, y = it.site
    state == 1 ? ((mod1(x + K, h), y), 2) :
    state == 2 ? ((x, mod1(y + K, w)), 3) :
    state == 3 ? ((mod1(x - K, h), y), 4) :
    state == 4 ? ((x, mod1(y - K, w)), 5) :
    nothing
end

function _iterate_even(it::NeighborSiteIterator{Tuple{h, w}, Periodic}, K, state) where {h, w}
    x, y = it.site
    state == 1 ? ((mod1(x + K, h), mod1(y + K, w)), 2) :
    state == 2 ? ((mod1(x - K, h), mod1(y + K, w)), 3) :
    state == 3 ? ((mod1(x - K, h), mod1(y - K, w)), 4) :
    state == 4 ? ((mod1(x + K, h), mod1(y - K, w)), 5) :
    nothing
end

@generated function Base.iterate(it::NeighborSiteIterator{<:Tuple, Periodic, K}, state=1) where K
    isodd(K) ? :(_iterate_odd(it, $(div(K, 2) + 1), state)) :
    :(_iterate_even(it, $(div(K, 2)), state))
end

function _iterate_odd(it::NeighborSiteIterator{Tuple{h, w}, Fixed}, K, state) where {h, w}
    x, y = it.site
    if (K < x < h - K + 1) && (K < y < w - K + 1)
        state == 1 ? ((x + K, y), 2) :
        state == 2 ? ((x, y + K), 3) :
        state == 3 ? ((x - K, y), 4) :
        state == 4 ? ((x, y - K), 5) :
        nothing
    elseif x == K
        if y == K
            state == 1 ? ((x + K, y), 2) :
            state == 2 ? ((x, y + K), 3) :
            nothing
        else
            state == 1 ? ((x + K, y), 2) :
            state == 2 ? (())
        end
        state == 1 ? (x + 1)
    elseif y == 1 || y == w
    end
end

function Base.iterate(it::NeighborSiteIterator{Tuple{h, w}, Fixed, K}, state=1) where {h, w}
    x, y = it.site
    if 1 < x < h && 1 < y < w
        state == 1 ? (x + 1, y), 2 :
        state == 2 ? (x, y + 1), 3 :
        state == 3 ? (x - 1, y), 4 :
        state == 4 ? (x, y - 1), 5 :
        nothing
    elseif x == h
        if 1 < y < w
            state == 1 ? (x, y + 1), 2 :
            state == 2 ? (x, y + 1), 3 :
            nothing
        elseif y == 1 || y == w
            state == 1 ? (x, y) :
            nothing
        end
    end
end
