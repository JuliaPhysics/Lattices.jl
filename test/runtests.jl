using Test, Lattices

@testset "Boundaries" begin
    @test Lattices.check_boundaries(Periodic(), Open()) == (Periodic(), Open())
    @test Lattices.check_boundaries(Helical(), Helical()) == (Helical(), Helical())

    @test Lattices.check_boundaries((Periodic(), Open())) == (Periodic(), Open())
    @test Lattices.check_boundaries((Helical(), Helical())) == (Helical(), Helical())

    @test_throws ArgumentError Lattices.check_boundaries(Periodic(), Helical())

end



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
        for k in 1:10
            @test Set(translation_vectors(HyperCubic{1}((10,)), k)) == Set([
                Coordinate(k), Coordinate(-k)
            ])
        end

        @test Set(translation_vectors(HyperCubic{2}((10,10)), 1)) == Set([
            Coordinate(1, 0),
            Coordinate(0, 1),
            Coordinate(-1, 0),
            Coordinate(0, -1)
        ])
        @test Set(translation_vectors(HyperCubic{3}((10,10,10)), 1)) == Set([
            Coordinate(1, 0, 0),
            Coordinate(0, 1, 0),
            Coordinate(0, 0, 1),
            Coordinate(-1, 0, 0),
            Coordinate(0, -1, 0),
            Coordinate(0, 0, -1)
        ])
        @test Set(translation_vectors(HyperCubic{4}((10,10,10,10)), 1)) == Set([
            Coordinate(1, 0, 0, 0),
            Coordinate(0, 1, 0, 0),
            Coordinate(0, 0, 1, 0),
            Coordinate(0, 0, 0, 1),
            Coordinate(-1, 0, 0, 0),
            Coordinate(0, -1, 0, 0),
            Coordinate(0, 0, -1, 0),
            Coordinate(0, 0, 0, -1),
        ])

        @test Set(translation_vectors(HyperCubic{2}((10,10)), 2)) == Set([
            Coordinate(1, 1),
            Coordinate(-1, 1),
            Coordinate(1, -1),
            Coordinate(-1, -1),
        ])

        @test Set(translation_vectors(HyperCubic{2}((10,10)), 3)) == Set([
            Coordinate(2, 0),
            Coordinate(0, 2),
            Coordinate(-2, 0),
            Coordinate(0, -2),
        ])
    end

    @testset "Basis Vectors" begin
        @test Set(basis_vectors(HyperCubic{1}((10,)))) == Set([
            Coordinate(1)
        ])
        @test Set(basis_vectors(HyperCubic{2}((10,10)))) == Set([
            Coordinate(1, 0), Coordinate(0, 1)
        ])
        @test Set(basis_vectors(HyperCubic{3}((10,10,10)))) == Set([
            Coordinate(1, 0, 0), Coordinate(0, 1, 0), Coordinate(0, 0, 1)
        ])
        @test Set(basis_vectors(HyperCubic{4}((10,10,10,10)))) == Set([
            Coordinate(1, 0, 0, 0), Coordinate(0, 1, 0, 0), Coordinate(0, 0, 1, 0), Coordinate(0, 0, 0, 1)
        ])
    end

    @testset "Neighbors" begin
        @testset "Chain Neighbors" begin
            @test neighbors(Chain(10, Periodic()), Coordinate(1)) == [Coordinate(10), Coordinate(2)]
            @test neighbors(Chain(10, Periodic()), Coordinate(5)) == [Coordinate(4), Coordinate(6)]
            @test neighbors(Chain(10, Periodic()), Coordinate(10)) == [Coordinate(9), Coordinate(1)]

            @test neighbors(Chain(10, Helical()), Coordinate(1)) == [Coordinate(10), Coordinate(2)]
            @test neighbors(Chain(10, Helical()), Coordinate(5)) == [Coordinate(4), Coordinate(6)]
            @test neighbors(Chain(10, Helical()), Coordinate(10)) == [Coordinate(9), Coordinate(1)]

            @test neighbors(Chain(10, Open()), Coordinate(1)) == [Coordinate(2)]
            @test neighbors(Chain(10, Open()), Coordinate(5)) == [Coordinate(4), Coordinate(6)]
            @test neighbors(Chain(10, Open()), Coordinate(10)) == [Coordinate(9)]
        end

        @testset "Square Neighbors" begin
            @test Set(neighbors(Square((10, 10), Periodic()), Coordinate(10,10))) == Set([Coordinate(10, 9), Coordinate(10, 1), Coordinate(1, 10), Coordinate(9, 10)])
            @test Set(neighbors(Square((10, 10), Periodic()), Coordinate(5,10))) == Set([Coordinate(5, 9), Coordinate(5, 1), Coordinate(4, 10), Coordinate(6, 10)])
            @test Set(neighbors(Square((10, 10), Periodic()), Coordinate(10,5))) == Set([Coordinate(10, 4), Coordinate(10, 6), Coordinate(9, 5), Coordinate(1, 5)])
            @test Set(neighbors(Square((10, 10), Periodic()), Coordinate(5,5))) == Set([Coordinate(5, 4), Coordinate(5, 6), Coordinate(4, 5), Coordinate(6, 5)])

            @test Set(neighbors(Square((10, 10), Open()), Coordinate(10,10))) == Set([Coordinate(10, 9), Coordinate(9, 10)])
            @test Set(neighbors(Square((10, 10), Open()), Coordinate(5,10))) == Set([Coordinate(5, 9), Coordinate(4, 10), Coordinate(6, 10)])
            @test Set(neighbors(Square((10, 10), Open()), Coordinate(10,5))) == Set([Coordinate(10, 4), Coordinate(10, 6), Coordinate(9, 5)])
            @test Set(neighbors(Square((10, 10), Open()), Coordinate(5,5))) == Set([Coordinate(5, 4), Coordinate(5, 6), Coordinate(4, 5), Coordinate(6, 5)])
        end
    end

    for N in 1:10
        @test ndims(HyperCubic{N}(ntuple(x->5, N))) == N
    end
end


@testset "Triangular" begin

    @test ndims(Triangular((10,5))) == 2

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

        @test Set(translation_vectors(Triangular((10,10)), 1)) == odd_vecs
        @test Set(translation_vectors(Triangular((10,10)), 2)) == even_vecs
        @test Set(translation_vectors(Triangular((10,10)), 3)) == Set(2 .* odd_vecs)

        @test Set(translation_vectors(Triangular((10,10)), 4)) == Set([
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
    end

    @testset "Basis Vectors" begin
        @test Set(basis_vectors(Triangular((10,10)))) == Set([
            Coordinate(1, 0),
            Coordinate(0, 1),
            Coordinate(1, -1)
        ])
    end


end