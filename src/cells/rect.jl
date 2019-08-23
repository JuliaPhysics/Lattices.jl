export HyperCube, UnitLine, Square, Cube

"""
    HyperCube{N} <: AbstractUnitCell{N}

`N`-dimensional hyper cube.
"""
struct HyperCube{N} <: AbstractUnitCell{N}
end

const UnitLine = HyperCube{1}
const Square = HyperCube{2}
const Cube = HyperCube{3}

Base.show(io::IO, x::UnitLine) = print(io, "UnitLine")
Base.show(io::IO, x::Square) = print(io, "Square")
Base.show(io::IO, x::Cube) = print(io, "Cube")
