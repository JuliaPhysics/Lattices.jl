sites(lattice::AbstractLattice) = (Coordinate(s.I) for s in CartesianIndices(axes(lattice)))

checkbounds(::Type{Bool}, L::AbstractLattice, I::Int...) = Base.checkbounds_indices(Bool, axes(L), I)
checkbounds(L::AbstractLattice, I::Int...) = checkbounds(Bool, L, I...) || throw(BoundsError(L, I))


@inline function to_site_id(lattice::AbstractLattice, coords::NTuple{N}) where N
    @boundscheck begin
        (N == ncoordinates(lattice)) || throw(ArgumentError("Incorrect number of coordinates! $(typeof(lattice)) expects $(ncoordinates(lattice)), got $N"))
        checkbounds(lattice, coords...)
    end

    sizes = (1, size(lattice)...)
    id = 0
    @inbounds for d in N:-1:1
        id += coords[d] - 1
        id *= sizes[d]
    end
    return id + 1  # 1-based indexing
end
Base.@propagate_inbounds to_site_id(lattice::AbstractLattice, coords::Coordinate) = to_site_id(lattice, coords.coordinates)


@inline function to_coordinate(lattice::AbstractLattice, site_id::Int)
    @boundscheck checkindex(Bool, 1:nsites(lattice), site_id) || throw(BoundsError(lattice, site_id))

    id = site_id - 1
    sizes = size(lattice)
    N = ncoordinates(lattice)
    coords = zeros(Int, N)

    @inbounds for d in 1:N-1
        id, c = divrem(id, sizes[d])
        coords[d] = c + 1
    end
    @inbounds coords[N] = id + 1

    return Coordinate(coords...)
end
