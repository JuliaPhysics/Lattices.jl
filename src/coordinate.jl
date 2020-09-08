struct Coordinate{N, T}
    coordinates::NTuple{N, T}
end

Coordinate(xs::T...) where T = Coordinate{length(xs), T}(xs)

for op in [:+, :-]
    @eval Base.$op(x::Coordinate, y::Coordinate) = Coordinate(map($op, x.coordinates, y.coordinates))
end

function Base.show(io::IO, x::Coordinate)
    print(io, "Coordinate(", join(x.coordinates, ", "), ")")
end
