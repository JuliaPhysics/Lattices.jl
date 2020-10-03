@testset "Triangular" begin

    @test ndims(Triangular((10, 5))) == 2

    @testset "Constructors" begin
        # test default BC
        @test Triangular((10, 5)) == Triangular((10, 5), Periodic())

        for B1 in [Periodic, Open, Helical]
            @test (
                Triangular((10, 5), B1())
                == Triangular((10, 5), (B1(), B1()))
                == Triangular((10, 5), B1())
                == Triangular((10, 5), (B1(), B1()))
            )
            if B1 != Helical
                for B2 in [Periodic, Open]
                    @test (
                        Triangular((10, 5), (B1(), B2()))
                        == Triangular((10, 5), (B1(), B2()))
                    )
                end
                @test_throws ArgumentError Triangular((10, 5), (B1(), Helical()))
            end
        end
    end

    @testset "Translation Vectors" begin
        l = Triangular((10, 10))

        odd_vecs = Set([
            Coordinate(1, 0),
            Coordinate(-1, 0),
            Coordinate(0, 1),
            Coordinate(0, -1),
            Coordinate(1, -1),
            Coordinate(-1, 1)
        ])

        even_vecs = Set([
            Coordinate(2, -1),
            Coordinate(-2, 1),
            Coordinate(1, 1),
            Coordinate(-1, 2),
            Coordinate(1, -2),
            Coordinate(-1, -1),
        ])

        # run k=4 first to fill cache
        @test Set(translation_vectors(l, 4)) == Set([
            Coordinate(2, 1),
            Coordinate(-2, -1),
            Coordinate(3, -1),
            Coordinate(-3, 1),

            Coordinate(2, -3),
            Coordinate(-2, 3),
            Coordinate(3, -2),
            Coordinate(-3, 2),

            Coordinate(1, -3),
            Coordinate(-1, 3),
            Coordinate(-1, -2),
            Coordinate(1, 2),
        ])

        @test Set(translation_vectors(l, 1)) == odd_vecs
        @test Set(translation_vectors(l, 2)) == even_vecs
        @test Set(translation_vectors(l, 3)) == Set(2 .* odd_vecs)

    end

    @testset "Nearest Neighbors" begin
        l = Triangular((10, 10), Periodic())
        @test Set(neighbors(l, Coordinate(10, 10))) == Set([Coordinate(10, 9), Coordinate(10, 1), Coordinate(1, 10), Coordinate(9, 10), Coordinate(1, 9), Coordinate(9, 1)])
        @test Set(neighbors(l, Coordinate(5, 10))) == Set([Coordinate(5, 9), Coordinate(5, 1), Coordinate(4, 10), Coordinate(6, 10), Coordinate(6, 9), Coordinate(4, 1)])
        @test Set(neighbors(l, Coordinate(10, 5))) == Set([Coordinate(10, 4), Coordinate(10, 6), Coordinate(9, 5), Coordinate(1, 5), Coordinate(1, 4), Coordinate(9, 6)])
        @test Set(neighbors(l, Coordinate(5, 5))) == Set([Coordinate(5, 4), Coordinate(5, 6), Coordinate(4, 5), Coordinate(6, 5), Coordinate(4, 6), Coordinate(6, 4)])

        l = Triangular((10, 10), Open())
        @test Set(neighbors(l, Coordinate(10, 10))) == Set([Coordinate(10, 9), Coordinate(9, 10)])
        @test Set(neighbors(l, Coordinate(5, 10))) == Set([Coordinate(5, 9), Coordinate(4, 10), Coordinate(6, 10), Coordinate(6, 9)])
        @test Set(neighbors(l, Coordinate(10, 5))) == Set([Coordinate(10, 4), Coordinate(10, 6), Coordinate(9, 5), Coordinate(9, 6)])
        @test Set(neighbors(l, Coordinate(5, 5))) == Set([Coordinate(5, 4), Coordinate(5, 6), Coordinate(4, 5), Coordinate(6, 5), Coordinate(4, 6), Coordinate(6, 4)])
    end

    @testset "Next Nearest Neighbors" begin
        l = Triangular((10, 10), Periodic())
        @test Set(neighbors(l, Coordinate(10, 10), 2)) == Set([Coordinate(2, 9), Coordinate(8, 1), Coordinate(1, 1), Coordinate(9, 2), Coordinate(1, 8), Coordinate(9, 9)])
        @test Set(neighbors(l, Coordinate(5, 10), 2)) == Set([Coordinate(7, 9), Coordinate(3, 1), Coordinate(6, 1), Coordinate(4, 2), Coordinate(6, 8), Coordinate(4, 9)])
        @test Set(neighbors(l, Coordinate(10, 5), 2)) == Set([Coordinate(2, 4), Coordinate(8, 6), Coordinate(1, 6), Coordinate(9, 7), Coordinate(1, 3), Coordinate(9, 4)])
        @test Set(neighbors(l, Coordinate(5, 5), 2)) == Set([Coordinate(7, 4), Coordinate(3, 6), Coordinate(6, 6), Coordinate(4, 7), Coordinate(6, 3), Coordinate(4, 4)])

        l = Triangular((10, 10), Open())
        @test Set(neighbors(l, Coordinate(10, 10), 2)) == Set([Coordinate(9, 9)])
        @test Set(neighbors(l, Coordinate(5, 10), 2)) == Set([Coordinate(7, 9), Coordinate(6, 8), Coordinate(4, 9)])
        @test Set(neighbors(l, Coordinate(10, 5), 2)) == Set([Coordinate(8, 6), Coordinate(9, 7), Coordinate(9, 4)])
        @test Set(neighbors(l, Coordinate(5, 5), 2)) == Set([Coordinate(7, 4), Coordinate(3, 6), Coordinate(6, 6), Coordinate(4, 7), Coordinate(6, 3), Coordinate(4, 4)])
    end
end
