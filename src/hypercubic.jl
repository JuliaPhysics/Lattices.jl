struct HyperCubic{N, B<:AbstractBoundary} <: AbstractLattice
    dims::NTuple{N, Int}
    bc::B
    function HyperCubic{N, B}(dims::NTuple{N, Int}, bc::B) where {N, B <: AbstractBoundary}
        if bc isa MixedBoundary && !(bc isa MixedBoundary{N})
            throw(ArgumentError("Given MixedBoundary should have same number of dimensions as the Lattice!"))
        end
        new{N, B}(dims, bc)
    end

    function HyperCubic{N, B}(dim::Int, bc::B) where {N, B <: AbstractBoundary}
        new{N, B}(ntuple(x->dim, N), bc)
    end
end

HyperCubic{N, B}(dims::NTuple{N, Int}) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dims, B())
HyperCubic{N, B}(dims::NTuple{N, Int}) where {N, B <: MixedBoundary} = error("Can't initialize HyperCubic with MixedBoundary just from type information!")


HyperCubic{N}(dims::NTuple{N, Int}, bc::B=Periodic()) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dims, bc)
HyperCubic(dims::NTuple{N, Int}, bc::B=Periodic()) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dims, bc)

HyperCubic{N, B}(dim::Int) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dim, B())
HyperCubic{N}(dim::Int, bc::B=Periodic()) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dim, bc)

const Chain = HyperCubic{1}
const Square = HyperCubic{2}
const Cubic = HyperCubic{3}

_apply_bc(::Type{Periodic}, length, coord) = mod(coord, 1:length)
_apply_bc(::Type{Open}, length, coord) = (1 <= coord <= length) ? coord : nothing
_apply_bc(bc::AbstractBoundary, length, coord) = _apply_bc(typeof(bc), length, coord)


function _apply_bcs(lattice::HyperCubic{N, Periodic}, site::Coordinate{N, Int})::Coordinate{N, Int} where N
    return Coordinate(_apply_bc.(Periodic, lattice.dims, site.coordinates)...)
end

function _apply_bcs(lattice::HyperCubic{N, MixedBoundary}, site::Coordinate{N, Int})::Union{Coordinate{N, Int}, Nothing} where N
    dims = lattice.dims
    bcs = lattice.bc.boundaries
    coords = site.coordinates
    clipped = []
    for i in 1:N
        c = _apply_bc(bcs[i], dims[i], coords[i])
        if isnothing(c)
            return nothing
        else
            push!(clipped, c)
        end
    end
    return Coordinate(clipped...)
end

function _apply_bcs(lattice::HyperCubic{N, <:AbstractBoundary}, site::Coordinate{N, Int})::Union{Coordinate{N, Int}, Nothing} where N
    dims = lattice.dims
    coords = site.coordinates
    bc = lattice.bc
    clipped = []
    for i in 1:N
        c = _apply_bc(bc, dims[i], coords[i])
        if isnothing(c)
            return nothing
        else
            push!(clipped, c)
        end
    end
    return Coordinate(clipped...)
end

# in 1D, Helical and Periodic BCs are equivalent
for BC in (:Periodic, :Helical)
    @eval function neighbors(lattice::Chain{$BC}, site::Coordinate{1, Int}, ::Val{k}) where k
        l = lattice.dims[1]
        c = site.coordinates[1]
        return [
            Coordinate(_apply_bc(Periodic, l, c - k)),
            Coordinate(_apply_bc(Periodic, l, c + k)),
        ]
    end
end

function neighbors(lattice::Chain{Open}, site::Coordinate{1, Int}, ::Val{k}) where k
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
    return filter(!isnothing, [_apply_bcs(lattice, n) for n in ns])
end
