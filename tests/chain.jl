using Test, Lattices

lattice = Chain(4)
nameof(lattice)
@test nameof(lattice) == "Chain Lattice"
@test collect(sites(lattice)) == [1, 2, 3, 4]
@test collect(edges(lattice)) == [(1, 2), (2, 3), (3, 4), (4, 1)]

@test lattice[1] == 1
@test lattice[2] == 2
@test lattice[3] == 3
@test lattice[4] == 4
@test lattice[5] == 1

lattice = Chain(4, boundary=Fixed)
@test_throws BoundsError lattice[5]
