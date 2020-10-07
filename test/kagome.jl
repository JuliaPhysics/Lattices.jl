
@testset "Kagome" begin

    @test ndims(Kagome((10,5))) == 2

    @testset "Constructors" begin
        # test default BC
        @test Kagome((10, 5)) == Kagome((10, 5), Periodic())

        for B1 in [Periodic, Open, Helical]
            @test (
                Kagome((10, 5), B1())
                == Kagome((10, 5), (B1(), B1()))
                == Kagome((10, 5), B1())
                == Kagome((10, 5), (B1(), B1()))
            )
            if B1 != Helical
                for B2 in [Periodic, Open]
                    @test (
                        Kagome((10, 5), (B1(), B2()))
                        == Kagome((10, 5), (B1(), B2()))
                    )
                end
                @test_throws ArgumentError Kagome((10, 5), (B1(), Helical()))
            end
        end
    end

    @testset "Translation Vectors" begin
        l = Kagome((10, 10))

        u1 = Set([
            Coordinate(0, 0, 2),
            Coordinate(0, 0, 3),
            Coordinate(-1, 0, 2),
            Coordinate(0, -1, 3)
        ])

        u2 = Set([
            Coordinate(0, 0, 1),
            Coordinate(0, 0, 3),
            Coordinate(1, 0, 1),
            Coordinate(1, -1, 3)
        ])

        u3 = Set([
            Coordinate(0, 0, 1),
            Coordinate(0, 0, 2),
            Coordinate(0, 1, 1),
            Coordinate(-1, 1, 2)
        ])

        @test Set(translation_vectors(l, 1, 1)) == u1
        @test Set(translation_vectors(l, 1, 2)) == u2
        @test Set(translation_vectors(l, 1, 3)) == u3
    end


    @testset "Nearest Neighbors" begin
        l = Kagome((10, 10), Periodic())
        @test Set(neighbors(l, Coordinate(10, 10, 1))) == Set([Coordinate(10, 10, 2), Coordinate(10, 10, 3), Coordinate(9, 10, 2), Coordinate(10, 9, 3)])
        @test Set(neighbors(l, Coordinate(5, 10, 1))) == Set([Coordinate(5, 10, 2), Coordinate(5, 10, 3), Coordinate(4, 10, 2), Coordinate(5, 9, 3)])
        @test Set(neighbors(l, Coordinate(10, 5, 1))) == Set([Coordinate(10, 5, 2), Coordinate(10, 5, 3), Coordinate(9, 5, 2), Coordinate(10, 4, 3)])
        @test Set(neighbors(l, Coordinate(5, 5, 1))) == Set([Coordinate(5, 5, 2), Coordinate(5, 5, 3), Coordinate(4, 5, 2), Coordinate(5, 4, 3)])

        @test Set(neighbors(l, Coordinate(10, 10, 2))) == Set([Coordinate(10, 10, 1), Coordinate(10, 10, 3), Coordinate(1, 10, 1), Coordinate(1, 9, 3)])
        @test Set(neighbors(l, Coordinate(5, 10, 2))) == Set([Coordinate(5, 10, 1), Coordinate(5, 10, 3), Coordinate(6, 10, 1), Coordinate(6, 9, 3)])
        @test Set(neighbors(l, Coordinate(10, 5, 2))) == Set([Coordinate(10, 5, 1), Coordinate(10, 5, 3), Coordinate(1, 5, 1), Coordinate(1, 4, 3)])
        @test Set(neighbors(l, Coordinate(5, 5, 2))) == Set([Coordinate(5, 5, 1), Coordinate(5, 5, 3), Coordinate(6, 5, 1), Coordinate(6, 4, 3)])

        @test Set(neighbors(l, Coordinate(10, 10, 3))) == Set([Coordinate(10, 10, 1), Coordinate(10, 10, 2), Coordinate(10, 1, 1), Coordinate(9, 1, 2)])
        @test Set(neighbors(l, Coordinate(5, 10, 3))) == Set([Coordinate(5, 10, 1), Coordinate(5, 10, 2), Coordinate(5, 1, 1), Coordinate(4, 1, 2)])
        @test Set(neighbors(l, Coordinate(10, 5, 3))) == Set([Coordinate(10, 5, 1), Coordinate(10, 5, 2), Coordinate(10, 6, 1), Coordinate(9, 6, 2)])
        @test Set(neighbors(l, Coordinate(5, 5, 3))) == Set([Coordinate(5, 5, 1), Coordinate(5, 5, 2), Coordinate(5, 6, 1), Coordinate(4, 6, 2)])

        l = Kagome((10, 10), Open())
        @test Set(neighbors(l, Coordinate(10, 10, 1))) == Set([Coordinate(10, 10, 2), Coordinate(10, 10, 3), Coordinate(9, 10, 2), Coordinate(10, 9, 3)])
        @test Set(neighbors(l, Coordinate(5, 10, 1))) == Set([Coordinate(5, 10, 2), Coordinate(5, 10, 3), Coordinate(4, 10, 2), Coordinate(5, 9, 3)])
        @test Set(neighbors(l, Coordinate(10, 5, 1))) == Set([Coordinate(10, 5, 2), Coordinate(10, 5, 3), Coordinate(9, 5, 2), Coordinate(10, 4, 3)])
        @test Set(neighbors(l, Coordinate(5, 5, 1))) == Set([Coordinate(5, 5, 2), Coordinate(5, 5, 3), Coordinate(4, 5, 2), Coordinate(5, 4, 3)])

        @test Set(neighbors(l, Coordinate(10, 10, 2))) == Set([Coordinate(10, 10, 1), Coordinate(10, 10, 3)])
        @test Set(neighbors(l, Coordinate(5, 10, 2))) == Set([Coordinate(5, 10, 1), Coordinate(5, 10, 3), Coordinate(6, 10, 1), Coordinate(6, 9, 3)])
        @test Set(neighbors(l, Coordinate(10, 5, 2))) == Set([Coordinate(10, 5, 1), Coordinate(10, 5, 3)])
        @test Set(neighbors(l, Coordinate(5, 5, 2))) == Set([Coordinate(5, 5, 1), Coordinate(5, 5, 3), Coordinate(6, 5, 1), Coordinate(6, 4, 3)])

        @test Set(neighbors(l, Coordinate(10, 10, 3))) == Set([Coordinate(10, 10, 1), Coordinate(10, 10, 2)])
        @test Set(neighbors(l, Coordinate(5, 10, 3))) == Set([Coordinate(5, 10, 1), Coordinate(5, 10, 2)])
        @test Set(neighbors(l, Coordinate(10, 5, 3))) == Set([Coordinate(10, 5, 1), Coordinate(10, 5, 2), Coordinate(10, 6, 1), Coordinate(9, 6, 2)])
        @test Set(neighbors(l, Coordinate(5, 5, 3))) == Set([Coordinate(5, 5, 1), Coordinate(5, 5, 2), Coordinate(5, 6, 1), Coordinate(4, 6, 2)])

    end

end
