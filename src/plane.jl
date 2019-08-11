struct Plane{BC <: BoundaryCond, N, TCell <: AbstractUnitCell{N}} <: AbstractLattice{N}
    shape::NTuple{N, Int}
    cells::TCell
end

shape(x::Plane) = x.shape
cell(x::Plane) = x.cells

function Base.iterate(it::SiteIt{Plane{Periodic, N}}, st) where N
end
