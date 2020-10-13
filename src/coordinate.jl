struct Coordinate{N, T <: Integer}
    coordinates::NTuple{N, T}
end

Coordinate(xs::T...) where T = Coordinate{length(xs), T}(xs)

for op in [:+, :-]
    @eval Base.$op(x::Coordinate{N}, y::Coordinate{N}) where N = Coordinate(map($op, x.coordinates, y.coordinates))

    @eval Base.$op(x::Coordinate{N}, y::AbstractVector) where N = $op(x, Coordinate(y...))
    @eval Base.$op(x::AbstractVector, y::Coordinate{N}) where N = $op(Coordinate(x...), y)

end


Base.:*(x::Coordinate, y::Int) = Coordinate(map(c -> y*c, x.coordinates))
Base.:*(x::Int, y::Coordinate) = y * x

Base.:-(x::Coordinate) = -1 * x

function Base.show(io::IO, x::Coordinate)
    print(io, "Coordinate(", join(x.coordinates, ", "), ")")
end
