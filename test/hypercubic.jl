@testset "HyperCubic" begin

    @testset "Constructors" begin
        @testset "Chain Constructors" begin
            @test HyperCubic{1}((10,)) == HyperCubic((10,)) == Chain(10) == Chain(10, Periodic())

            for B in [Periodic, Open, Helical]
                @test HyperCubic{1}((10,), (B(),)) == HyperCubic{1}((10,), B()) == Chain(10, B()) == Chain(10, (B(),))
                @test HyperCubic((10,), (B(),)) == HyperCubic((10,), B()) == Chain(10, B()) == Chain(10, (B(),))
            end
        end

        @testset "Square Constructors" begin
            # test default BC
            @test HyperCubic{2}((10, 5)) == Square((10, 5), Periodic()) == Square((10, 5))

            for B1 in [Periodic, Open, Helical]
                @test (
                    HyperCubic{2}((10, 5), B1())
                    == HyperCubic{2}((10, 5), (B1(), B1()))
                    == HyperCubic((10, 5), B1())
                    == HyperCubic((10, 5), (B1(), B1()))
                    == Square((10, 5), B1())
                    == Square((10, 5), (B1(), B1()))
                )
                if B1 != Helical
                    for B2 in [Periodic, Open]
                        @test (
                            HyperCubic{2}((10, 5), (B1(), B2()))
                            == HyperCubic((10, 5), (B1(), B2()))
                            == Square((10, 5), (B1(), B2()))
                        )
                    end
                    @test_throws ArgumentError Square((10, 5), (B1(), Helical()))
                end
            end

        end


        @testset "Cubic Constructors" begin
            # test default BC
            @test HyperCubic{3}((10, 5, 7)) == Cubic((10, 5, 7), Periodic()) == Cubic((10, 5, 7))

            for B1 in [Periodic, Open, Helical]
                @test (
                    HyperCubic{3}((10, 5, 7), B1())
                    == HyperCubic{3}((10, 5, 7), (B1(), B1(), B1()))
                    == HyperCubic((10, 5, 7), B1())
                    == HyperCubic((10, 5, 7), (B1(), B1(), B1()))
                    == Cubic((10, 5, 7), B1())
                    == Cubic((10, 5, 7), (B1(), B1(), B1()))
                )
                if B1 != Helical
                    for B2 in [Periodic, Open]
                        for B3 in [Periodic, Open]
                            @test (
                                HyperCubic{3}((10, 5, 7), (B1(), B2(), B3()))
                                == HyperCubic((10, 5, 7), (B1(), B2(), B3()))
                                == Cubic((10, 5, 7), (B1(), B2(), B3()))
                            )
                        end
                        @test_throws ArgumentError Cubic((10, 5, 7), (B1(), B2(), Helical()))
                    end
                    @test_throws ArgumentError Cubic((10, 5, 7), (B1(), Helical(), Helical()))
                end
            end

        end
    end

    @testset "Translation Vectors" begin
        l = HyperCubic{1}((10,))
        for k in 10:-1:1
            @test Set(translation_vectors(l, k)) == Set([
                Coordinate(k), Coordinate(-k)
            ])
        end

        @test Set(translation_vectors(HyperCubic{3}((10, 10, 10)), 1)) == Set([
            Coordinate(1, 0, 0),
            Coordinate(0, 1, 0),
            Coordinate(0, 0, 1),
            Coordinate(-1, 0, 0),
            Coordinate(0, -1, 0),
            Coordinate(0, 0, -1)
        ])
        @test Set(translation_vectors(HyperCubic{4}((10, 10, 10, 10)), 1)) == Set([
            Coordinate(1, 0, 0, 0),
            Coordinate(0, 1, 0, 0),
            Coordinate(0, 0, 1, 0),
            Coordinate(0, 0, 0, 1),
            Coordinate(-1, 0, 0, 0),
            Coordinate(0, -1, 0, 0),
            Coordinate(0, 0, -1, 0),
            Coordinate(0, 0, 0, -1),
        ])

        l = HyperCubic{2}((10, 10))
        @test Set(translation_vectors(l, 3)) == Set([
            Coordinate(2, 0),
            Coordinate(0, 2),
            Coordinate(-2, 0),
            Coordinate(0, -2),
        ])
        @test Set(translation_vectors(l, 2)) == Set([
            Coordinate(1, 1),
            Coordinate(-1, 1),
            Coordinate(1, -1),
            Coordinate(-1, -1),
        ])
        @test Set(translation_vectors(l, 1)) == Set([
            Coordinate(1, 0),
            Coordinate(0, 1),
            Coordinate(-1, 0),
            Coordinate(0, -1)
        ])
    end

    @testset "Neighbors" begin
        @testset "Chain Neighbors" begin
            l = Chain(10, Periodic())
            @test neighbors(l, Coordinate(1)) == [Coordinate(10), Coordinate(2)]
            @test neighbors(l, Coordinate(5)) == [Coordinate(4), Coordinate(6)]
            @test neighbors(l, Coordinate(10)) == [Coordinate(9), Coordinate(1)]

            l = Chain(10, Helical())
            @test neighbors(l, Coordinate(1)) == [Coordinate(10), Coordinate(2)]
            @test neighbors(l, Coordinate(5)) == [Coordinate(4), Coordinate(6)]
            @test neighbors(l, Coordinate(10)) == [Coordinate(9), Coordinate(1)]

            l = Chain(10, Open())
            @test neighbors(l, Coordinate(1)) == [Coordinate(2)]
            @test neighbors(l, Coordinate(5)) == [Coordinate(4), Coordinate(6)]
            @test neighbors(l, Coordinate(10)) == [Coordinate(9)]
        end

        @testset "Square Neighbors" begin
            l = Square((10, 10), Periodic())
            @test Set(neighbors(l, Coordinate(10, 10))) == Set([Coordinate(10, 9), Coordinate(10, 1), Coordinate(1, 10), Coordinate(9, 10)])
            @test Set(neighbors(l, Coordinate(5, 10))) == Set([Coordinate(5, 9), Coordinate(5, 1), Coordinate(4, 10), Coordinate(6, 10)])
            @test Set(neighbors(l, Coordinate(10, 5))) == Set([Coordinate(10, 4), Coordinate(10, 6), Coordinate(9, 5), Coordinate(1, 5)])
            @test Set(neighbors(l, Coordinate(5, 5))) == Set([Coordinate(5, 4), Coordinate(5, 6), Coordinate(4, 5), Coordinate(6, 5)])

            l = Square((10, 10), Open())
            @test Set(neighbors(l, Coordinate(10, 10))) == Set([Coordinate(10, 9), Coordinate(9, 10)])
            @test Set(neighbors(l, Coordinate(5, 10))) == Set([Coordinate(5, 9), Coordinate(4, 10), Coordinate(6, 10)])
            @test Set(neighbors(l, Coordinate(10, 5))) == Set([Coordinate(10, 4), Coordinate(10, 6), Coordinate(9, 5)])
            @test Set(neighbors(l, Coordinate(5, 5))) == Set([Coordinate(5, 4), Coordinate(5, 6), Coordinate(4, 5), Coordinate(6, 5)])
        end
    end

    @testset "ndims" begin
        for N in 1:10
            @test ndims(HyperCubic{N}(ntuple(x->5, N))) == N
        end
    end
end
