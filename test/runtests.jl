using Test, Lattices

@testset "Boundaries" begin
    @test Lattices.check_boundaries(Periodic(), Open()) == (Periodic(), Open())
    @test Lattices.check_boundaries(Helical(), Helical()) == (Helical(), Helical())

    @test Lattices.check_boundaries((Periodic(), Open())) == (Periodic(), Open())
    @test Lattices.check_boundaries((Helical(), Helical())) == (Helical(), Helical())

    @test_throws ArgumentError Lattices.check_boundaries(Periodic(), Helical())

end

include("hypercubic.jl")
include("triangular.jl")
include("honeycomb.jl")
include("kagome.jl")
