function sites(::Val{false}, lattice::AbstractLattice)
    dim_ranges = [1:d for d in lattice.dims]
    (Coordinate(t...) for t in CartesianIndices(dim_ranges...))
end

function sites(::Val{true}, lattice::AbstractLattice)
    dim_ranges = [1:d for d in lattice.dims]
    (Coordinate(t...) for t in CartesianIndices(dim_ranges..., 1:unitcellsize(lattice)))
end

sites(lattice::AbstractLattice) = sites(hasunitcell(lattice), lattice)
