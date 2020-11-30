using Test, Lattices

@testset "Boundaries" begin
    @test Lattices.check_boundaries(Periodic(), Open()) == (Periodic(), Open())
    @test Lattices.check_boundaries(Helical(), Helical()) == (Helical(), Helical())

    @test Lattices.check_boundaries((Periodic(), Open())) == (Periodic(), Open())
    @test Lattices.check_boundaries((Helical(), Helical())) == (Helical(), Helical())

    @test_throws ArgumentError Lattices.check_boundaries(Periodic(), Helical())

end

@testset "Site IDs" begin
    # test 1D lattice
    for len in [1, 5, 10]
        l = Chain(len)
        for i in 1:len
            @test to_coordinate(l, to_site_id(l, Coordinate(i))) == Coordinate(i)
            @test to_site_id(l, to_coordinate(l, i)) == i
            @test to_coordinate(l, i) == Coordinate(i)
        end
    end

    # test a simple high-dimensional lattice
    l = HyperCubic((5,4,2,7))
    @test to_coordinate(l, to_site_id(l, Coordinate(1,1,1,1))) === Coordinate(1,1,1,1)  # origin
    @test to_coordinate(l, to_site_id(l, Coordinate(2,3,1,6))) === Coordinate(2,3,1,6)  # random bulk site
    @test to_coordinate(l, to_site_id(l, Coordinate(5,4,2,7))) === Coordinate(5,4,2,7)  # "last" site
    @test to_site_id(l, to_coordinate(l, 1)) == 1
    @test to_site_id(l, to_coordinate(l, nsites(l)÷10)) == nsites(l)÷10
    @test to_site_id(l, to_coordinate(l, nsites(l))) == nsites(l)
    @test to_coordinate(l, 1) == Coordinate(1,1,1,1)
    @test to_coordinate(l, nsites(l)) == Coordinate(5,4,2,7)

    @test_throws BoundsError to_coordinate(l, 0)
    @test_throws BoundsError to_coordinate(l, nsites(l)+1)
    @test_throws BoundsError to_site_id(l, Coordinate(0,0,0,0))
    @test_throws BoundsError to_site_id(l, Coordinate(2,3,4,6))
    @test_throws BoundsError to_site_id(l, Coordinate(5,4,2,8))

    @test (@inbounds to_site_id(l, Coordinate(5,4,2,8))) > nsites(l)
    @test (@inbounds to_site_id(l, Coordinate(5,4,2))) != 0
    @test (@inbounds to_site_id(l, Coordinate(5,4,2,7,1))) != 0

    # test case of non-trivial unit-cell
    l = Kagome((5,7))
    @test to_coordinate(l, to_site_id(l, Coordinate(1,1,1))) === Coordinate(1,1,1)  # origin
    @test to_coordinate(l, to_site_id(l, Coordinate(2,3,2))) === Coordinate(2,3,2)  # random bulk site
    @test to_coordinate(l, to_site_id(l, Coordinate(5,7,3))) === Coordinate(5,7,3)  # "last" site
    @test to_site_id(l, to_coordinate(l, 1)) == 1
    @test to_site_id(l, to_coordinate(l, nsites(l)÷6)) == nsites(l)÷6
    @test to_site_id(l, to_coordinate(l, nsites(l))) == nsites(l)
    @test to_coordinate(l, 1) == Coordinate(1,1,1)
    @test to_coordinate(l, nsites(l)) == Coordinate(5,7,3)

    @test_throws BoundsError to_coordinate(l, 0)
    @test_throws BoundsError to_coordinate(l, nsites(l)+1)
    @test_throws BoundsError to_site_id(l, Coordinate(0,0,0))
    @test_throws BoundsError to_site_id(l, Coordinate(2,3,4))
    @test_throws BoundsError to_site_id(l, Coordinate(5,7,4))
end

include("hypercubic.jl")
include("triangular.jl")
include("honeycomb.jl")
include("kagome.jl")
