function Lattices.edges(lattice::Square; length::Int=1)
    if isodd(length)
        k = (length + 1) ÷ 2
        FusedEdgesIterator(
            EdgesIterator{:vertical, k}(lattice),
            EdgesIterator{:horizontal, k}(lattice)
        )
    else
        k = length ÷ 2
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
