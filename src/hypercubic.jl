struct HyperCubic{N, B<:NTuple{N, AbstractBoundary}} <: AbstractLattice
    dims::NTuple{N, Int}
    bc::B
    translation_vectors::Dict{Int, Vector{Coordinate{N, Int}}}
    function HyperCubic{N, B}(dims::NTuple{N, Int}, bc::B) where {N, B <: NTuple{N, AbstractBoundary}}
        check_boundaries(bc)
        new{N, B}(dims, bc, Dict{Int, Vector{Coordinate{N, Int}}}())
    end
end

==(a::HyperCubic{N, B}, b::HyperCubic{N, B}) where {N, B <: NTuple{N, AbstractBoundary}} = (
    a.dims === b.dims
    && a.bc == b.bc
    && a.translation_vectors == b.translation_vectors
)
==(a::HyperCubic, b::HyperCubic) = false

ndims(::HyperCubic{N}) where N = N

################
## Constructors
################

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


#############################
## Translation/Basis Vectors
#############################

metric(::HyperCubic{N}) where N = I(N)
function precompute_translation_vectors!(lattice::HyperCubic{1}, maximum_k::Int)
    d = lattice.translation_vectors
    for i in 1:maximum_k
        d[i] = [Coordinate(i), Coordinate(-i)]
    end
    return d
end
basis_vectors(lattice::HyperCubic{N}) where N = [Coordinate(v...) for v in eachcol(Diagonal{Int}(I, N))]


#######################
## Boundary Conditions
#######################

apply_boundary(::Periodic, length::Int, x::Int) = mod(x, 1:length)
apply_boundary(::Open, length::Int, x::Int) = (1 <= x <= length) ? x : nothing


function apply_boundary_conditions(lattice::HyperCubic{N, NTuple{N, Periodic}}, site::Coordinate{N, Int})::Coordinate{N, Int} where N
    return Coordinate(apply_boundary.(lattice.bc, lattice.dims, site.coordinates)...)
end

# in 1D, Helical and Periodic BCs are equivalent
function apply_boundary_conditions(lattice::HyperCubic{1, NTuple{1, Helical}}, site::Coordinate{1, Int})::Coordinate{1, Int}
    return Coordinate(apply_boundary.((Periodic(),), lattice.dims, site.coordinates)...)
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


#############
## Neighbors
#############

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

function neighbors(lattice::Chain{NTuple{1,Open}}, site::Coordinate{1, Int}, ::Val{K}) where K
    l = lattice.dims[1]
    sp, sm = site + Coordinate(K), site - Coordinate(K)
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


function neighbors(lattice::HyperCubic{N, NTuple{N, Periodic}}, site::Coordinate{N, Int}, ::Val{K}) where {N,K}
    return [apply_boundary_conditions(lattice, n) for n in _neighbors(lattice, site, K)]
end

function neighbors(lattice::HyperCubic{N, NTuple{N, Helical}}, site::Int, ::Val{1}) where {N}
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
