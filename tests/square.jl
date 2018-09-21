using Test, Lattices

lattice = Square(4, 5)

test_sites = []
for i = 1:5
    for j = 1:4
        push!(test_sites, (j, i))
    end
end
test_sites
@test collect(sites(lattice)) == test_sites
edges(lattice)
