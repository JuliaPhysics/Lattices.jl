struct Periodic end
struct Open end

struct HyperRect{BC, N}
    shape::NTuple{N, Int}
    stride::NTuple{N, Int}
end

const Chain{BC} = HyperRect{BC, 1}
const Square{BC} = HyperRect{BC, 2}
const Rect{BC} = HyperRect{BC, 2}

function HyperRect{BC}(shape::Dims{N}) where {N, BC}
    HyperRect{BC, N}(shape, Base.size_to_strides(1, shape...))
end

HyperRect{BC}(shape...) where BC = HyperRect{BC}(shape)
Chain{BC}(x::Int) where BC = HyperRect{BC}(x)
Square{BC}(x::Int) where BC = HyperRect{BC}(x, x)
Rect{BC}(x::Int, y::Int) where BC = HyperRect{BC}(x, y)

# default boundary
HyperRect(shape...) = HyperRect{Periodic}(shape...)
Chain(x::Int) = Chain{Periodic}(x)
Square(x::Int) = Square{Periodic}(x)
Rect(x::Int, y::Int) = Rect{Periodic}(x, y)

Base.length(l::HyperRect) = prod(l.shape)
Base.size(l::HyperRect) = l.shape
Base.size(l::HyperRect, k) = l.shape[k]

Base.show(io::IO, x::HyperRect{BC, N}) where {BC, N} =
    print(io, "HyperRect{$BC}", x.shape)
Base.show(io::IO, x::HyperRect{BC, 1}) where {BC} =
    print(io, "Chain{$BC}(", x.shape[1], ")")

function Base.show(io::IO, x::HyperRect{BC, 2}) where BC
    if x.shape[1] == x.shape[2]
        print(io, "Square{$BC}(", x.shape[1], ")")
    else
        print(io, "Rect{$BC}", x.shape)
    end
end

struct Coordinate{N}
    xs::NTuple{N, Int}
end

Coordinate(xs...) = Coordinate(xs)

Base.show(io::IO, x::Coordinate) = print(io, "Coordinate", x.xs)
Base.show(io::IO, x::Coordinate{1}) = print(io, "Coordinate(", x.xs[1], ")")

function to_coordinate(l::HyperRect{BC, N}, k::Int) where {BC, N}
    @assert 1 <= k <= length(l) "site id is too large, expect 1 <= $k <= $(length(l))"
    t = k - 1
    xs = zeros(Int, N)
    for i in N:-1:2
        xs[i] = t ÷ l.stride[i] + 1
        t = t - (xs[i] - 1) * l.stride[i]
    end
    xs[1] = t + 1
    return Coordinate(xs...)
end

struct SiteIt{L}
    l::L
end

Base.length(it::SiteIt{<:HyperRect}) = length(it.l)
Base.size(it::SiteIt) = size(it.l)
Base.eltype(it::SiteIt{HyperRect{BC, N}}) where {BC, N} = Coordinate{N}
Base.IteratorSize(::Type{<:SiteIt{L}}) where {BC, N, L <: HyperRect{BC, N}} = Base.HasShape{N}()

function Base.iterate(it::SiteIt{<:HyperRect}, st=1)
    st > length(it) && return nothing
    to_coordinate(it.l, st), st + 1
end


struct EdgeIt{L, K}
    l::L
end

Base.size(it::EdgeIt{HyperRect{Periodic, N}}) where N = size(it.l)
Base.length(it::EdgeIt{HyperRect{Periodic, N}}) where N = length(it.l)
Base.eltype(it::EdgeIt{HyperRect{Periodic, N}}) where N = NTuple{2, Coordinate{N}}
Base.IteratorSize(::Type{<:EdgeIt{L}}) where {BC, N, L <: HyperRect{BC, N}} = Base.HasShape{N}()

function Base.iterate(it::EdgeIt{<:HyperRect{Periodic, N}, K}, st=1) where {N, K}
    st > length(it) && return nothing
    to_coordinate(st) + 
end

l = HyperRect{Open}(2, 3)

to_coordinate(l, 3)

collect(SiteIt(l))

HyperRect{Open}(2) |> typeof

Chain{Open}(2)

Square{Open}(2).stride

Rect(2, 3)

