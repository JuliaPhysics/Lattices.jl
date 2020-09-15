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



# @testset "HyperCubic" begin
#     @testset "Constructors" begin
#         @test Chain(10)
#         @test Chain(10, Periodic())
#         @test Chain(10, Open())
#         @test Chain(10, Helical())
#     end

# end
