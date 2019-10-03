abstract type Boundary end
struct Open <: Boundary end
struct Periodic <: Boundary end

struct Square{BC <: Boundary, N} end

Square{BC}(n::Int) where BC = Square{BC, n}()
Square(n::Int) = Square{Periodic}(n)

Base.size(l::Square{BC, N}) where {BC, N} = (N, N)
Base.length(l::Square{BC, N}) where {BC, N} = N * N

Base.show(io::IO, x::Square{BC, N}) where {BC, N} = print(io, "Square{$BC}(", N, ")")

struct Coordinate{N}
    xs::NTuple{N, Int}
end

Coordinate(xs...) = Coordinate(xs)

Base.length(::Coordinate{N}) where N = N
Base.size(::Coordinate{N}) where N = (N, )
Base.iterate(coo::Coordinate, st=1) = iterate(coo.xs, st)
Base.getindex(coo::Coordinate, idx::Int) = coo.xs[idx]
Base.eltype(::Coordinate) = Int
Base.show(io::IO, x::Coordinate) = print(io, "Coordinate", x.xs)
Base.show(io::IO, x::Coordinate{1}) = print(io, "Coordinate(", x.xs[1], ")")

function to_coordinate(l::Square{BC, N}, k::Int) where {BC, N}
    @assert 1 <= k <= length(l) "site id is too large, expect 1 <= k <= $(length(l))"
    t = k - 1
    x2 = t ÷ N + 1
    t = t - (x2 - 1) * N
    x1 = t + 1
    return Coordinate(x1, x2)
end

function to_siteid(l::Square{BC, N}, x::Coordinate{2}) where {BC, N}
    x1, x2 = x
    return x1 + (x2 - 1) * N
end

struct SiteIt{L}
    lattice::L
end

Base.length(::SiteIt{<:Square{BC, N}}) where {BC, N} = N * N
Base.size(::SiteIt{<:Square{BC, N}}) where {BC, N} = (N, N)
Base.eltype(::SiteIt{<:Square}) = Int
Base.IteratorSize(::Type{<:SiteIt{Square{BC, N}}}) where {BC, N} = Base.HasShape{2}()

function Base.iterate(it::SiteIt{<:Square}, st=1)
    st > length(it) && return nothing
    st, st + 1
end

struct EdgeIt{L, K}
    lattice::L
end

Base.length(::EdgeIt{<:Square{Periodic, N}}) where N = 2N * N

struct SquareEdgeState{D}
    st::Int
end

Base.:(+)(st::SquareEdgeState{D}, x::Int) where D = SquareEdgeState{D}(st.st + x)

function Base.iterate(it::EdgeIt{<:Square, K}) where K
    if isodd(K)
        return iterate(it, SquareEdgeState{:-}(1))
    else
        return iterate(it, SquareEdgeState{:/}(1))
    end
end

function Base.iterate(it::EdgeIt{<:Square{Periodic, N}, K}, st::SquareEdgeState{:-}) where {K, N}
    id = st.st
    distance = K ÷ 2 + 1
    id > length(it.lattice) && return iterate(it, SquareEdgeState{:|}(1))

    x1, x2 = to_coordinate(it.lattice, id)
    y1 = mod1(x1 + distance, N)
    y2 = x2
    return (id, to_siteid(it.lattice, Coordinate(y1, y2))), st + 1
end

function Base.iterate(it::EdgeIt{<:Square{Periodic, N}, K}, st::SquareEdgeState{:|}) where {K, N}
    id = st.st
    distance = K ÷ 2 + 1
    id > length(it.lattice) && return nothing

    x1, x2 = to_coordinate(it.lattice, id)
    y1 = x1
    y2 = mod1(x2 + distance, N)
    return (id, to_siteid(it.lattice, Coordinate(y1, y2))), st + 1
end

function Base.iterate(it::EdgeIt{<:Square{Periodic, N}, K}, st::SquareEdgeState{:/}) where {K, N}
    id = st.st
    distance = K ÷ 2
    id > length(it.lattice) && return nothing

    x1, x2 = to_coordinate(it.lattice, id)
    y1 = mod1(x1 + distance, N)
    y2 = mod1(x2 + distance, N)
    return (id, to_siteid(it.lattice, Coordinate(y1, y2))), st + 1
end

function Base.iterate(it::EdgeIt{<:Square{Periodic, N}, K}, st::SquareEdgeState{:\}) where {K, N}
    id = st.st
    distance = K ÷ 2
    id > length(it.lattice) && return nothing

    x1, x2 = to_coordinate(it.lattice, id)
    y1 = mod1(x1 + distance, N)
    y2 = mod1(x2 - distance, N)
    return (id, to_siteid(it.lattice, Coordinate(y1, y2))), st + 1
end

l = Square(3)

SiteIt(l)|>collect
EdgeIt{typeof(l), 1}(l)|>collect

count = 1
for each in EdgeIt{typeof(l), 1}(l)
    @show each
    global count += 1
end
count
to_siteid(l, to_coordinate(l, 4))

