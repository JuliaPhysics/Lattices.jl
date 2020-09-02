using Test, Lattices

@testset "HyperCubic" begin
    @testset "Constructors" begin
        @test Chain(10)
        @test Chain(10, Periodic)
        @test Chain(10, Open)
        @test Chain(10, Helical)
    end

end
