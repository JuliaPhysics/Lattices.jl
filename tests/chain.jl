using Test, Lattices

lattice = Chain(4)
nameof(lattice)
@test nameof(lattice) == "Chain Lattice"
@test collect(sites(lattice)) == [1, 2, 3, 4]
@test collect(edges(lattice)) == [(1, 2), (2, 3), (3, 4), (4, 1)]
