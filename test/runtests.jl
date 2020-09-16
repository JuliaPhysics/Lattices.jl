using Test, Lattices

@testset "Boundaries" begin
    for T in [Periodic, Helical, Open]
        @test MixedBoundary((T(),)) == T() == MixedBoundary(T())
        @test MixedBoundary(T(), T()) == T()
    end

    @test MixedBoundary((Periodic(), Open())) == MixedBoundary([Periodic(), Open()]) == MixedBoundary(Periodic(), Open())

    @test_throws ArgumentError MixedBoundary((Periodic(), Helical()))
    @test_throws ArgumentError MixedBoundary(
        MixedBoundary(Periodic(), Open()),
        Open()
    )
end



@testset "HyperCubic" begin
    @testset "Constructors" begin
        @testset "Chain Constructors" begin
            @test HyperCubic{1, Periodic}(10) == Chain{Periodic}(10) == Chain(10)
            @test HyperCubic{1, Periodic}(10) == Chain(10, Periodic())
            @test HyperCubic{1, Open}(10) == Chain(10, Open()) == Chain{Open}(10)
            @test HyperCubic{1, Helical}(10) == Chain(10, Helical()) == Chain{Helical}(10)
        end

        @testset "Square Constructors" begin
            @test HyperCubic{2, Periodic}((10,10)) == HyperCubic{2, Periodic}(10)
            @test HyperCubic{2, Periodic}(10) == Square{Periodic}(10) == Square(10)
            @test HyperCubic{2, Periodic}(10) == Square(10, Periodic())
            @test HyperCubic{2, Open}(10) == Square(10, Open()) == Square{Open}(10)
            @test HyperCubic{2, Helical}(10) == Square(10, Helical()) == Square{Helical}(10)

            @test HyperCubic{2, Periodic}((10, 5)) == Square{Periodic}((10, 5)) == Square((10, 5))
            @test HyperCubic{2, Periodic}((10, 5)) == Square((10, 5), Periodic())
            @test HyperCubic{2, Open}((10, 5)) == Square((10, 5), Open()) == Square{Open}((10, 5))
            @test HyperCubic{2, Helical}((10, 5)) == Square((10, 5), Helical()) == Square{Helical}((10, 5))

            @test HyperCubic((10, 5), MixedBoundary(Periodic(), Open())) == Square((10, 5), MixedBoundary(Periodic(), Open()))
        end


        @testset "SimpleCubic Constructors" begin
            @test HyperCubic{3, Periodic}((10,10,10)) == HyperCubic{3, Periodic}(10)
            @test HyperCubic{3, Periodic}(10) == SimpleCubic{Periodic}(10) == SimpleCubic(10)
            @test HyperCubic{3, Periodic}(10) == SimpleCubic(10, Periodic())
            @test HyperCubic{3, Open}(10) == SimpleCubic(10, Open()) == SimpleCubic{Open}(10)
            @test HyperCubic{3, Helical}(10) == SimpleCubic(10, Helical()) == SimpleCubic{Helical}(10)

            @test HyperCubic{3, Periodic}((10, 5, 7)) == SimpleCubic{Periodic}((10, 5, 7)) == SimpleCubic((10, 5, 7))
            @test HyperCubic{3, Periodic}((10, 5, 7)) == SimpleCubic((10, 5, 7), Periodic())
            @test HyperCubic{3, Open}((10, 5, 7)) == SimpleCubic((10, 5, 7), Open()) == SimpleCubic{Open}((10, 5, 7))
            @test HyperCubic{3, Helical}((10, 5, 7)) == SimpleCubic((10, 5, 7), Helical()) == SimpleCubic{Helical}((10, 5, 7))

            @test HyperCubic((10, 5, 7), MixedBoundary(Periodic(), Open(), Periodic())) == SimpleCubic((10, 5, 7), MixedBoundary(Periodic(), Open(), Periodic()))
        end
    end

    @testset "Translation Vectors" begin
        # @test Set(Lattices.translation_vectors(HyperCubic{1}((10,)), Val(1))) == Set([
        #     Coordinate(1), Coordinate(-1)
        # ]) TODO: resolve method ambiguity
        @test Set(Lattices.translation_vectors(HyperCubic{2}((10,10)), Val(1))) == Set([
            Coordinate(1, 0),
            Coordinate(0, 1),
            Coordinate(-1, 0),
            Coordinate(0, -1)
        ])
        @test Set(Lattices.translation_vectors(HyperCubic{3}((10,10,10)), Val(1))) == Set([
            Coordinate(1, 0, 0),
            Coordinate(0, 1, 0),
            Coordinate(0, 0, 1),
            Coordinate(-1, 0, 0),
            Coordinate(0, -1, 0),
            Coordinate(0, 0, -1)
        ])
        @test Set(Lattices.translation_vectors(HyperCubic{4}((10,10,10,10)), Val(1))) == Set([
            Coordinate(1, 0, 0, 0),
            Coordinate(0, 1, 0, 0),
            Coordinate(0, 0, 1, 0),
            Coordinate(0, 0, 0, 1),
            Coordinate(-1, 0, 0, 0),
            Coordinate(0, -1, 0, 0),
            Coordinate(0, 0, -1, 0),
            Coordinate(0, 0, 0, -1),
        ])

        @test Set(Lattices.translation_vectors(HyperCubic{1}((10,)), Val(2))) == Set([
            Coordinate(2), Coordinate(-2)
        ])
        # @test Lattices.translation_vectors(HyperCubic{2}, Val(1)) == Set([
        #     Coordinate(1, 1),
        #     Coordinate(-1, 1),
        #     Coordinate(1, -1),
        #     Coordinate(-1, -1),
        # ])
        # @test Lattices.translation_vectors(HyperCubic{3}, Val(1)) == Set([
        #     Coordinate(1, 0, 0), Coordinate(0, 1, 0), Coordinate(0, 0, 1)
        # ])
        # @test Lattices.translation_vectors(HyperCubic{4}, Val(1)) == Set([
        #     Coordinate(1, 0, 0, 0), Coordinate(0, 1, 0, 0), Coordinate(0, 0, 1, 0), Coordinate(0, 0, 0, 1)
        # ])

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
            @test Set(neighbors(Square(10, Periodic()), Coordinate(10,10))) == Set([Coordinate(10, 9), Coordinate(10, 1), Coordinate(1, 10), Coordinate(9, 10)])
            @test Set(neighbors(Square(10, Periodic()), Coordinate(5,10))) == Set([Coordinate(5, 9), Coordinate(5, 1), Coordinate(4, 10), Coordinate(6, 10)])
            @test Set(neighbors(Square(10, Periodic()), Coordinate(10,5))) == Set([Coordinate(10, 4), Coordinate(10, 6), Coordinate(9, 5), Coordinate(1, 5)])
            @test Set(neighbors(Square(10, Periodic()), Coordinate(5,5))) == Set([Coordinate(5, 4), Coordinate(5, 6), Coordinate(4, 5), Coordinate(6, 5)])

            @test Set(neighbors(Square(10, Open()), Coordinate(10,10))) == Set([Coordinate(10, 9), Coordinate(9, 10)])
            @test Set(neighbors(Square(10, Open()), Coordinate(5,10))) == Set([Coordinate(5, 9), Coordinate(4, 10), Coordinate(6, 10)])
            @test Set(neighbors(Square(10, Open()), Coordinate(10,5))) == Set([Coordinate(10, 4), Coordinate(10, 6), Coordinate(9, 5)])
            @test Set(neighbors(Square(10, Open()), Coordinate(5,5))) == Set([Coordinate(5, 4), Coordinate(5, 6), Coordinate(4, 5), Coordinate(6, 5)])

        end
    end
end
