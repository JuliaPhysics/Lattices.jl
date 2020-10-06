bonds(lattice::AbstractLattice, k::Int) = ((s, n) for s in sites(lattice) for n in neighbors(lattice, s, k))
bonds(lattice::AbstractLattice) = bonds(lattice, 1)
