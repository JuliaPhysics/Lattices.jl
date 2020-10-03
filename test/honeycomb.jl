@testset "Honeycomb" begin

    @test ndims(Honeycomb((10, 5))) == 2

    @testset "Constructors" begin
        # test default BC
        @test Honeycomb((10, 5)) == Honeycomb((10, 5), Periodic())

        for B1 in [Periodic, Open, Helical]
            @test (
                Honeycomb((10, 5), B1())
                == Honeycomb((10, 5), (B1(), B1()))
                == Honeycomb((10, 5), B1())
                == Honeycomb((10, 5), (B1(), B1()))
            )
            if B1 != Helical
                for B2 in [Periodic, Open]
                    @test (
                        Honeycomb((10, 5), (B1(), B2()))
                        == Honeycomb((10, 5), (B1(), B2()))
                    )
                end
                @test_throws ArgumentError Honeycomb((10, 5), (B1(), Helical()))
            end
        end
    end

    @testset "Translation Vectors" begin
        l = Honeycomb((10, 10))

        @testset "Bipartite Lattice" begin
            # note: this only works for k < 4, for the same reason that
            #  the triangular lattice's translation vectors stop being
            #  "scaled" versions of the k=1,2 translation vectors at k=4

            for k in 3:-1:1  # iterate backwards to make use of caching
                u1 = map(x -> x.coordinates[end], translation_vectors(l, k, 1))
                u2 = map(x -> x.coordinates[end], translation_vectors(l, k, 2))

                @test all(==(u1[1]), u1)
                @test all(==(u2[1]), u2)

                if isodd(k)
                    @test u1[1] == 2
                    @test u2[1] == 1
                else
                    @test u1[1] == 1
                    @test u2[1] == 2
                end
            end
        end

        u1 = Set([Coordinate(0, 0, 2), Coordinate(0, -1, 2), Coordinate(-1, 0, 2)])
        u2 = Set([Coordinate(0, 0, 1), Coordinate(0, 1, 1), Coordinate(1, 0, 1)])

        @test Set(translation_vectors(l, 1, 1)) == u1
        @test Set(translation_vectors(l, 1, 2)) == u2
    end


    @testset "Nearest Neighbors" begin
        l = Honeycomb((10, 10), Periodic())
        @test Set(neighbors(l, Coordinate(10, 10, 1))) == Set([Coordinate(10, 10, 2), Coordinate(10, 9, 2), Coordinate(9, 10, 2)])
        @test Set(neighbors(l, Coordinate(5, 10, 1))) == Set([Coordinate(5, 10, 2), Coordinate(5, 9, 2), Coordinate(4, 10, 2)])
        @test Set(neighbors(l, Coordinate(10, 5, 1))) == Set([Coordinate(10, 5, 2), Coordinate(10, 4, 2), Coordinate(9, 5, 2)])
        @test Set(neighbors(l, Coordinate(5, 5, 1))) == Set([Coordinate(5, 5, 2), Coordinate(5, 4, 2), Coordinate(4, 5, 2)])

        @test Set(neighbors(l, Coordinate(10, 10, 2))) == Set([Coordinate(10, 10, 1), Coordinate(10, 1, 1), Coordinate(1, 10, 1)])
        @test Set(neighbors(l, Coordinate(5, 10, 2))) == Set([Coordinate(5, 10, 1), Coordinate(5, 1, 1), Coordinate(6, 10, 1)])
        @test Set(neighbors(l, Coordinate(10, 5, 2))) == Set([Coordinate(10, 5, 1), Coordinate(10, 6, 1), Coordinate(1, 5, 1)])
        @test Set(neighbors(l, Coordinate(5, 5, 2))) == Set([Coordinate(5, 5, 1), Coordinate(5, 6, 1), Coordinate(6, 5, 1)])

        l = Honeycomb((10, 10), Open())
        @test Set(neighbors(l, Coordinate(10, 10, 1))) == Set([Coordinate(10, 10, 2), Coordinate(10, 9, 2), Coordinate(9, 10, 2)])
        @test Set(neighbors(l, Coordinate(5, 10, 1))) == Set([Coordinate(5, 10, 2), Coordinate(5, 9, 2), Coordinate(4, 10, 2)])
        @test Set(neighbors(l, Coordinate(10, 5, 1))) == Set([Coordinate(10, 5, 2), Coordinate(10, 4, 2), Coordinate(9, 5, 2)])
        @test Set(neighbors(l, Coordinate(5, 5, 1))) == Set([Coordinate(5, 5, 2), Coordinate(5, 4, 2), Coordinate(4, 5, 2)])

        @test Set(neighbors(l, Coordinate(10, 10, 2))) == Set([Coordinate(10, 10, 1)])
        @test Set(neighbors(l, Coordinate(5, 10, 2))) == Set([Coordinate(5, 10, 1), Coordinate(6, 10, 1)])
        @test Set(neighbors(l, Coordinate(10, 5, 2))) == Set([Coordinate(10, 5, 1), Coordinate(10, 6, 1)])
        @test Set(neighbors(l, Coordinate(5, 5, 2))) == Set([Coordinate(5, 5, 1), Coordinate(5, 6, 1), Coordinate(6, 5, 1)])
    end

end
