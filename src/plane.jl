export Plane

struct Plane{BC <: BoundaryCond, N, TCell <: AbstractUnitCell{N}} <: AbstractLattice{N}
    cells::TCell
    shape::NTuple{N, Int}
end

Plane{B}(cell::C, shape::NTuple{N, Int}) where {B, N, C} = Plane{B, N, C}(shape, cell)
Plane{B}(::Type{<:HyperCube}, shape::NTuple{N, Int}) where {B, N} = Plane{B, N, HyperCube{N}}(HyperCube{N}(), shape)
Plane{B}(c, shape...) where B = Plane{B}(c, shape)

shape(x::Plane) = x.shape
shape(x::Plane, k) = x.shape[k]
cell(x::Plane) = x.cells

function Base.show(io::IO, x::Plane{BC, N}) where {BC, N}
    print(io, "Plane{", BC, "}(", x.cells, ", ", x.shape, ")")
end

# sites
Base.length(it::SiteIt{Plane{<:BoundaryCond, N, HyperCube{N}}}) where N = prod(shape(it))
Base.size(it::SiteIt{Plane{<:BoundaryCond, N, HyperCube{N}}}) where N = shape(it)
Base.iterate(it::SiteIt{Plane{<:BoundaryCond, N, HyperCube{N}}}) where N =
    iterate(CartesianIndices(Base.OneTo.(shape(it))))
Base.iterate(it::SiteIt{Plane{<:BoundaryCond, N, HyperCube{N}}}, st) where N =
    iterate(CartesianIndices(Base.OneTo.(shape(it))), st)
Base.IteratorSize(::Type{<:SiteIt{Plane{<:BoundaryCond, N, HyperCube{N}}}}) where N = Base.HasShape{N}()
Base.eltype(it::SiteIt{Plane{<:BoundaryCond, N, HyperCube{N}}}) where N = CartesianIndex{N}

function Base.getindex(l::Plane{<:BoundaryCond, N, HyperCube{N}}, x::CartesianIndex{N}) where N
    stride = 1
    id = 0
    for k in 1:N
        id += x.I[k] * stride
        stride *= shape(l, k)
    end
    return id
end

Base.getindex(l::Plane{<:BoundaryCond, N, HyperCube{N}}, xs::Int...) where N = l[CartesianIndex(xs)]

# edges
function Base.iterate(it::EdgeIt{Plane{<:BoundaryCond, N, HyperCube{N}}}, st) where N
end

@generated function create_edge(it::EdgeIt{Plane{Open, N, HyperCube{N}}}, ::Val{K}, s) where {N, K}
    ex = Expr(:call, GlobalRef(Base, :CartesianIndex))
    for i in 1:N
        if i == K
            push!(ex.args, :(s[$K] + it.distance))
        else
            push!(ex.args, :(s[$i]))
        end
    end
    return ex
end

@generated function create_edge(it::EdgeIt{Plane{Periodic, N, HyperCube{N}}}, ::Val{K}, s) where {N, K}
    ex = Expr(:call, GlobalRef(Base, :CartesianIndex))
    for i in 1:N
        if i == K
            push!(ex.args, :(mod1(s[$K] + it.distance, shape(it, $K))))
        else
            push!(ex.args, :(s[$i]))
        end
    end
    return ex
end
