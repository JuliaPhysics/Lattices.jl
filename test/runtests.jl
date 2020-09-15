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
