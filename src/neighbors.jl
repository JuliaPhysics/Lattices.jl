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


function precompute_translation_vectors!(lattice::AbstractLattice, maximum_k::Int)
    if maximum_k < 0
        throw(ArgumentError("maximum_k must be non-negative!"))
    end

    N = ndims(lattice)
    g = metric(lattice)

    # TODO: need to test this on lattices with non-diagonal metrics
    tv = _all_translation_vectors(N, maximum_k)
    if !isdiag(g)
        tv = _all_signed_translation_vectors(tv)
        tv = reshape(tv, N, :)
        tv = unique(tv; dims=2)
    end

    norms = dropdims(sum(tv .* (g * tv); dims = 1); dims = 1)
    p = sortperm(norms)

    norms = norms[p]
    tv = tv[:, p]
    if isdiag(g)
        stv = _all_signed_translation_vectors(tv)
    else
        stv = reshape(tv, size(tv)..., 1)
    end

    uniq = sort!(unique(norms))
    uniq = filter(!iszero, uniq)

    d = lattice.translation_vectors
    for k in 1:maximum_k
        idx = findall(uniq[k] .== norms)
        d[k] = ([
            Coordinate(v...)
            for tv in eachslice(@view stv[:, idx, :]; dims=3)
            for v in eachcol(tv)
        ])
    end
    return d
end


function translation_vectors(lattice::AbstractLattice, k::Int)
    if !(k in keys(lattice.translation_vectors))
        precompute_translation_vectors!(lattice, k)
    end

    return lattice.translation_vectors[k]
end


basis_vectors(lattice::AbstractLattice) = filter(translation_vectors(lattice, 1)) do v
    all(>=(0), v.coordinates)
end


_neighbors(lattice::AbstractLattice, site::Coordinate, k::Int) = map(v -> site + v, translation_vectors(lattice, k))


function neighbors(lattice::AbstractLattice, site::Coordinate{N, Int}, ::Val{K}) where {N,K}
    ns = _neighbors(lattice, site, K)
    return filter(!isnothing, [apply_boundary_conditions(lattice, n) for n in ns])
end

neighbors(lattice::AbstractLattice, site::Coordinate, k::Int) = neighbors(lattice, site, Val{k}())
neighbors(lattice::AbstractLattice, site::Coordinate) = neighbors(lattice, site, Val{1}())