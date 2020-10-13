function _all_translation_vectors(dim::Int, max_component::Int)::Array{Int, 2}
    out = zeros(Int, dim, (max_component+1)^dim)
    @inbounds for i in axes(out, 2)
        k = i-1
        for l in dim:-1:1
            k, out[l, i] = divrem(k, max_component+1)
        end
    end
    return out
end

function _all_signed_translation_vectors(tv::Array{Int, 2})::Array{Int, 3}
    dim = size(tv, 1)
    stv = zeros(Int, dim, size(tv, 2), (2^dim))

    signs = 2*_all_translation_vectors(dim, 1) .- 1

    @inbounds for i in axes(signs, 2)
        @views stv[:, :, i] = signs[:, i] .* tv
    end
    return stv
end

# acts as a bias term before computing the norm
function _add_unit_cell_index(lattice::AbstractLattice, tv::Array{Int, 2})::Array{Int, 3}
    dim = size(tv, 1)
    ucsize = unitcellsize(lattice)
    utv = zeros(Int, dim+1, size(tv, 2), ucsize)

    for u in 1:ucsize
        utv[1:end-1, :, u] = tv
        utv[end, :, u] .= u
    end
    return utv
end



function _norm2(::Val{true}, lattice::AbstractLattice, v::AbstractVector)
    uv = unitcell_translation_vectors(lattice)
    u = v[1:end-1] + uv[:, Int(v[end])]
    return dot(u, metric(lattice), u)
end

_norm2(::Val{false}, lattice::AbstractLattice, v::AbstractVector) = dot(v, metric(lattice), v)

norm2(lattice::AbstractLattice, v::AbstractVector) = _norm2(hasunitcell(lattice), lattice, v)
norm(lattice::AbstractLattice, v::AbstractVector) = sqrt(norm2(lattice, v))


function _approx_uniq(x::AbstractVector, maximum_k::Int)
    uniq_ = filter(!iszero, sort!(unique(x)))
    uniq = Float64[]
    for i in axes(uniq_, 1)
        if length(uniq) == 0 || !(last(uniq) ≈ uniq_[i])
            push!(uniq, uniq_[i])
        end
        if length(uniq) >= maximum_k
            break
        end
    end
    return uniq
end


function _generate_all_translation_vectors!(::Val{true}, lattice::AbstractLattice, maximum_k::Int)
    N = ndims(lattice)

    tv = _all_translation_vectors(N, maximum_k)
    tv = _all_signed_translation_vectors(tv)
    tv = reshape(tv, N, :)
    tv = unique(tv; dims=2)
    tv = _add_unit_cell_index(lattice, tv)
    tv = reshape(tv, size(tv, 1), :)

    d = lattice.translation_vectors

    uv = unitcell_translation_vectors(lattice)

    for u in 1:unitcellsize(lattice)
        norms = [
            norm2(lattice, [v[1:end-1] - uv[:, u]; v[end]])
            for v in eachcol(tv)
        ]

        p = sortperm(norms)

        norms = norms[p]
        utv = tv[:, p]

        uniq = _approx_uniq(norms, maximum_k)

        for k in 1:maximum_k
            idx = findall(uniq[k] .≈ norms)
            d[(k, u)] = [Coordinate(v...) for v in eachcol(@views utv[:, idx])]
        end
    end

    return d
end


function _generate_all_translation_vectors!(::Val{false}, lattice::AbstractLattice, maximum_k::Int)
    N = ndims(lattice)

    tv = _all_translation_vectors(N, maximum_k)
    if !ismetricdiag(lattice)
        tv = _all_signed_translation_vectors(tv)
        tv = reshape(tv, N, :)
        tv = unique(tv; dims=2)
    end

    norms = [norm2(lattice, v) for v in eachcol(tv)]
    p = sortperm(norms)

    norms = norms[p]
    tv = tv[:, p]
    if ismetricdiag(lattice)
        stv = _all_signed_translation_vectors(tv)
    else
        stv = reshape(tv, size(tv)..., 1)
    end

    uniq = _approx_uniq(norms, maximum_k)

    d = lattice.translation_vectors
    for k in 1:maximum_k
        idx = findall(uniq[k] .≈ norms)
        d[k] = ([
            Coordinate(v...)
            for tv in eachslice(@view stv[:, idx, :]; dims=3)
            for v in eachcol(tv)
        ])
    end
    return d
end


precompute_translation_vectors!(lattice, maximum_k) = (
    maximum_k <= 0
    ? throw(ArgumentError("maximum_k must be positive!"))
    : _generate_all_translation_vectors!(hasunitcell(lattice), lattice, maximum_k)
)


function _translation_vectors(::Val{false}, lattice::AbstractLattice, k::Int, ::Nothing)
    if !(k in keys(lattice.translation_vectors))
        precompute_translation_vectors!(lattice, k)
    end
    return lattice.translation_vectors[k]
end


function _translation_vectors(::Val{true}, lattice::AbstractLattice, k::Int, u::Int)
    if !(k in first.(keys(lattice.translation_vectors)))
        precompute_translation_vectors!(lattice, k)
    end
    return lattice.translation_vectors[(k, u)]
end


function _translation_vectors(::Val{true}, lattice::AbstractLattice, k::Int, ::Nothing)
    if !(k in first.(keys(lattice.translation_vectors)))
        precompute_translation_vectors!(lattice, k)
    end
    d = Dict{Int, Vector{Coordinate{ncoordinates(lattice), Int}}}()
    for u in 1:unitcellsize(lattice)
        d[u] = lattice.translation_vectors[(k, u)]
    end
    return d
end

function translation_vectors(lattice::AbstractLattice, k::Int, u::Union{Int, Nothing}=nothing)
    return _translation_vectors(hasunitcell(lattice), lattice, k, u)
end

_neighbors(b::Val{false}, lattice::AbstractLattice, site::Coordinate, k::Int) = map(v -> site + v, _translation_vectors(b, lattice, k, nothing))
function _neighbors(b::Val{true}, lattice::AbstractLattice, site::Coordinate, k::Int)
    tv = _translation_vectors(b, lattice, k, site.coordinates[end])

    ns = Vector{Coordinate{ncoordinates(lattice), Int}}(undef, length(tv))

    for i in axes(ns, 1)
        ns[i] = Coordinate(
            map(+, site.coordinates[1:end-1], tv[i].coordinates[1:end-1])...,
            tv[i].coordinates[end]
        )
    end
    return ns
end

function neighbors(lattice::AbstractLattice, site::Coordinate{N, Int}, ::Val{K}) where {N,K}
    ns = _neighbors(hasunitcell(lattice), lattice, site, K)
    return filter(!isnothing, [apply_boundary_conditions(lattice, n) for n in ns])
end

neighbors(lattice::AbstractLattice, site::Coordinate, k::Int) = neighbors(lattice, site, Val{k}())
neighbors(lattice::AbstractLattice, site::Coordinate) = neighbors(lattice, site, Val{1}())
