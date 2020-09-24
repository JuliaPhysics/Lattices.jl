import Base: size, ndims, length, show, nameof

"""
    AbstractLattice

Abstract type for general lattices.
For a more concrete definition please refer the following material:

- Lattice (group): https://en.wikipedia.org/wiki/Lattice_(group)
- Lattice Model: https://en.wikipedia.org/wiki/Lattice_model_(physics)
- Lattice Graph: https://en.wikipedia.org/wiki/Lattice_graph
"""
abstract type AbstractLattice end

struct WeightedLattice{L <: AbstractLattice, W} <: AbstractLattice
    lattice::L
    weights::W
end

struct CoordinateLattice{L <: AbstractLattice, Coordinate} <: AbstractLattice
    lattice::L
    coordinates::Vector{Coordinate}
end

struct GraphLattice{Graph} <: AbstractLattice
    graph::Graph
end


# struct HasCoordinate end

# function coordinate(::HoneyComb, id)
# end

# function coordinate(lattice, id)
# end

# function coordinate(::HasCoordinate, lattice, id)
# end

# for (i, j) in edges(lattice; bond=k)
# end

# # <=>
# for i in sites(lattice)
#     for j in neighbors(lattice, i, k)
#         if i < j
#             value = get_term(H, i, j)
#         end
#     end
# end

# struct SitesIt{L}
#     lattice::L
# end

# struct BondsIt{L}
#     lattice::L
#     bond::Int
# end

# function sites end
# function neighbors end
# function bonds end

# Base.iterate(it::BondsIt, st) = iterate_lattice(it, it.lattice, st)
# function iterate_lattice(::BondsIt, lattice, st) end


# Common functions for
for LatName in [:HoneyComb, :Triangular, :Kagome]
    @eval struct $LatName{B <: NTuple{2, AbstractBoundary}} <: AbstractLattice
        dims::NTuple{2, Int}
        bc::NTuple{2, AbstractBoundary}
        translation_vectors::Dict{Int, Vector{Coordinate{2, Int}}}
        function $LatName{B}(dims::NTuple{2, Int}, bc::B) where B <: NTuple{2, AbstractBoundary}
            check_boundaries(bc)
            new{B}(dims, bc, Dict{Int, Vector{Coordinate{2, Int}}}())
        end
    end

    @eval ==(a::$LatName{B}, b::$LatName{B}) where B <: NTuple{2, AbstractBoundary} = (
        a.dims === b.dims
        && a.bc == b.bc
        && a.translation_vectors == b.translation_vectors
    )
    @eval ==(a::$LatName, b::$LatName) = false

    @eval ndims(::$LatName) = 2

    ################
    ## Constructors
    ################

    @eval $LatName(dims::NTuple{2, Int}, bcs::NTuple{2, AbstractBoundary}) = $LatName{typeof(bcs)}(dims, bcs)
    @eval $LatName(dims::NTuple{2, Int}, bc::AbstractBoundary=Periodic()) = $LatName(dims, ntuple(x->bc, 2))
end
