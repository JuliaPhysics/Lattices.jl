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

function check_index(lattice::Square{Tuple{h, w}, Periodic}) where {h, w}
    count = 1
    for i = 1:w
        for j = 1:h
            @test lattice[j, i] == count
            count += 1
        end
    end

    @test lattice[h+1, 2] == lattice[1, 2]
    @test lattice[2, w+1] == lattice[2, 1]

    true
end

function check_index(lattice::Square{Tuple{h, w}, Fixed}) where {h, w}
    count = 1
    for i = 1:w
        for j = 1:h
            @test lattice[j, i] == count
            count += 1
        end
    end
    true
end

@test check_index(Square(4, 5, boundary=Periodic))
@test check_index(Square(4, 5, boundary=Fixed))

lattice = Square(4, 5, boundary=Fixed)
@test_throws BoundsError lattice[1, 6]
