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

HyperCubic{N, B}(dims::NTuple{N, Int}) where {N, B <: PrimitiveBoundary} = HyperCubic{N, B}(dims, B())

HyperCubic{N}(dims::NTuple{N, Int}, bc::B=Periodic()) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dims, bc)
HyperCubic(dims::NTuple{N, Int}, bc::B=Periodic()) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dims, bc)

HyperCubic{N, B}(dim::Int) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dim, B())
HyperCubic{N}(dim::Int, bc::B=Periodic()) where {N, B <: AbstractBoundary} = HyperCubic{N, B}(dim, bc)

const Chain = HyperCubic{1}
const Square = HyperCubic{2}
const SimpleCubic = HyperCubic{3}

_apply_bc(::Type{Periodic}, length, coord) = mod(coord, 1:length)
_apply_bc(::Type{Open}, length, coord) = (1 <= coord <= length) ? coord : nothing
_apply_bc(bc::AbstractBoundary, length, coord) = _apply_bc(typeof(bc), length, coord)


function _apply_bcs(lattice::HyperCubic{N, Periodic}, site::SVector{N, Int})::SVector{N, Int} where N
    dims = lattice.dims
    return _apply_bc.(Periodic, dims, site)
end

function _apply_bcs(lattice::HyperCubic{N, MixedBoundary}, site::SVector{N, Int})::Union{SVector{N, Int}, Nothing} where N
    dims = lattice.dims
    bcs = lattice.bc.boundaries
    clipped = []
    for i in 1:N
        c = _apply_bc(bcs[i], dims[i], site[i])
        if isnothing(c)
            return nothing
        else
            push!(clipped, c)
        end
    end
    return SVector{N}(clipped)
end

function _apply_bcs(lattice::HyperCubic{N, Open}, site::SVector{N, Int})::Union{SVector{N, Int}, Nothing} where N
    dims = lattice.dims
    clipped = []
    for i in 1:N
        c = _apply_bc(Open, dims[i], site[i])
        if isnothing(c)
            return nothing
        else
            push!(clipped, c)
        end
    end
    return SVector{N}(clipped)
end

# in 1D, Helical and Periodic BCs are equivalent
for BC in (:Periodic, :Helical)
    @eval function neighbors(lattice::Chain{$BC}, site::Int, ::Val{k}) where k
        l = lattice.dims[1]
        return _apply_bc.(Periodic, l, [site - k, site + k])
    end
end

function neighbors(lattice::Chain{Open}, site::Int, ::Val{k}) where k
    l = lattice.dims[1]
    sp, sm = site + k, site - k
    if sp > l
        if sm < 1
            return []
        else
            return [sm]
        end
    else
        if sm < 1
            return [sp]
        else
            return [sm, sp]
        end
    end
end


basis_vectors(lattice::HyperCubic{N}) where N = eachrow(SMatrix{N, N}(I))
translation_vectors(lattice::HyperCubic, k::Val{1}) = basis_vectors(lattice)

function _neighbors(lattice::HyperCubic{N}, site::SVector{N, Int}, k::Val{1}) where N
    bv = translation_vectors(lattice)
    return flatten((
        (site + v for i in bv),
        (site - v for i in bv)
    ))
end


function neighbors(lattice::HyperCubic{N}, site::SVector{N, Int}, k::Val{K}) where {N,K}
    ns = _neighbors(lattice, site, k)
    return filter(!isnothing, (_apply_bcs(lattice, n) for n in ns))
end
