@reexport module SquareLattice
export Square

using Lattices: BoundaryCondition, Fixed, Periodic, BoundedLattice
import Lattices

const SiteType = Tuple{Int, Int}
const EdgeType = Tuple{SiteType, SiteType}

"""
    Square{Shape, BC} <: BoundedLattice{2, BC}

Square lattice.
"""
struct Square{Shape, BC <: BoundaryCondition} <: BoundedLattice{2, BC} end

# alias
const FixedSquare{h, w} = Square{Tuple{h, w}, Fixed} where {h, w}
const PeriodicSquare{h, w} = Square{Tuple{h, w}, Periodic} where {h, w}

"""
    Square(height, width; [boundary=Periodic])

Returns a square lattice with given `height` and `width`, `boundary` is set to `Periodic`
by default.
"""
Square(height::Int, width::Int; boundary=Periodic) = Square{Tuple{height, width}, boundary}()

Base.size(::Square{Tuple{height, width}}) where {height, width} = (height, width)
Base.length(::Square{Tuple{height, width}}) where {height, width} = height * width
Base.nameof(::Square) = "Square Lattice"

Base.getindex(lattice::Square, inds::Int...) = getindex(lattice, inds)
Base.getindex(lattice::FixedSquare{h, w}, inds::NTuple{2, Int}) where h where w =
    inds[1] > h ? throw(BoundsError(lattice, inds)) :
    inds[2] > w ? throw(BoundsError(lattice, inds)) :
    inds[1] + (inds[2] - 1) * h
Base.getindex(lattice::PeriodicSquare{h, w}, inds::NTuple{2, Int}) where h where w =
    mod1(inds[1], h) + mod(inds[2] - 1, w) * h

(ltc::FixedSquare{h, w})(s::Int) where {h, w} =
    s > length(ltc) || s < 1 ? throw(BoundsError(ltc, s)) :
    mod1(s, h), div(s - 1, h) + 1

(ltc::PeriodicSquare{h, w})(s::Int) where {h, w} =
    mod1(s, h), div(s - 1, h) + 1

# iterators
include("sites.jl")
include("edges.jl")
# include("surround.jl")

end
