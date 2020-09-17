struct HyperCubic{N, B<:NTuple{N, AbstractBoundary}} <: AbstractLattice
    dims::NTuple{N, Int}
    bc::B
    function HyperCubic{N, B}(dims::NTuple{N, Int}, bc::B) where {N, B <: NTuple{N, AbstractBoundary}}
        check_boundaries(bc)
        new{N, B}(dims, bc)
    end
end

HyperCubic{N}(dims::NTuple{N, Int}, bcs::NTuple{N, AbstractBoundary}) where N = HyperCubic{N, typeof(bcs)}(dims, bcs)
function HyperCubic{N}(dims::NTuple{N, Int}, bc::AbstractBoundary=Periodic()) where N
    bcs = ntuple(x->bc, N)
    HyperCubic{N, typeof(bcs)}(dims, bcs)
end

HyperCubic(dims::NTuple{N, Int}, bc) where N = HyperCubic{N}(dims, bc)
HyperCubic(dims::NTuple{N, Int}) where N = HyperCubic{N}(dims)

const Chain = HyperCubic{1}
Chain(dim::Int, bc) = Chain((dim,), bc)
Chain(dim::Int) = Chain((dim,))

const Square = HyperCubic{2}
const Cubic = HyperCubic{3}

apply_boundary(::Periodic, length::Int, x::Int) = mod(x, 1:length)
apply_boundary(::Open, length::Int, x::Int) = (1 <= x <= length) ? x : nothing


function apply_boundary_conditions(lattice::HyperCubic{N, NTuple{N, Periodic}}, site::Coordinate{N, Int})::Coordinate{N, Int} where N
    return Coordinate(apply_boundary.(lattice.bc, lattice.dims, site.coordinates)...)
end

function apply_boundary_conditions(lattice::HyperCubic{N, NTuple{N, B}}, site::Coordinate{N, Int})::Union{Coordinate{N, Int}, Nothing} where {N, B <: AbstractBoundary}
    dims = lattice.dims
    bcs = lattice.bc
    coords = site.coordinates
    clipped = []
    for i in 1:N
        c = apply_boundary(bcs[i], dims[i], coords[i])
        if isnothing(c)
            return nothing
        else
            push!(clipped, c)
        end
    end
    return Coordinate(clipped...)
end


# in 1D, Helical and Periodic BCs are equivalent
for BC in (:Periodic, :Helical), k in (:1, :K)
    @eval function neighbors(lattice::Chain{NTuple{1,$BC}}, site::Coordinate{1, Int}, ::Val{$k}) where K
        l = lattice.dims[1]
        c = site.coordinates[1]
        return [
            Coordinate(apply_boundary(Periodic(), l, c - $k)),
            Coordinate(apply_boundary(Periodic(), l, c + $k)),
        ]
    end
end

function neighbors(lattice::Chain{NTuple{1,Open}}, site::Coordinate{1, Int}, ::Val{k}) where k
    l = lattice.dims[1]
    sp, sm = site + Coordinate(k), site - Coordinate(k)
    if sp.coordinates[1] > l
        if sm.coordinates[1] < 1
            return []
        else
            return [sm]
        end
    else
        if sm.coordinates[1] < 1
            return [sp]
        else
            return [sm, sp]
        end
    end
end
translation_vectors(lattice::HyperCubic{1}, k::Val{K}) where K = flatten((
    map(c -> K*c, basis_vectors(lattice)),
    map(c -> -K*c, basis_vectors(lattice)),
))

basis_vectors(lattice::HyperCubic{N}) where N = [Coordinate(Int.(v)...) for v in eachrow(Diagonal(I, N))]
translation_vectors(lattice::HyperCubic{N}, k::Val{1}) where N = flatten((
    basis_vectors(lattice), -basis_vectors(lattice)
))


function _neighbors(lattice::HyperCubic{N}, site::Coordinate{N, Int}, k::Val{K}) where {N,K}
    bv = translation_vectors(lattice, k)
    return (site + v for v in bv)
end


function neighbors(lattice::HyperCubic{N}, site::Coordinate{N, Int}, k::Val{K}) where {N,K}
    ns = _neighbors(lattice, site, k)
    return filter(!isnothing, [apply_boundary_conditions(lattice, n) for n in ns])
end


function neighbors(lattice::HyperCubic{N, NTuple{N, Helical}}, site::Int, k::Val{1}) where {N}
    shifts = cumprod(lattice.dims)
    linear_size = shifts[end]
    shifts = [1; shifts[1:end-1]]

    ns = Vector{Int}(undef, 2*N)

    for i in 1:N
        ns[i] = mod(site + shifts[i], 1:linear_size)
        ns[i + N] = mod(site - shifts[i], 1:linear_size)
    end
    return ns
end
neighbors(lattice::HyperCubic{N, NTuple{N, Helical}}, site::Coordinate{N, Int}, k) where N = neighbors(
    lattice,
    sum(map(*, [1; cumprod(lattice.dims[1:end-1])], site.coordinates .- 1)),
    k
)
