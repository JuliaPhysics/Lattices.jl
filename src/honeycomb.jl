
struct HoneyComb <: AbstractCoordinateLattice{2}
    dims::NTuple{2, Int}
    boundaries::NTuple{2, AbstractBoundary}
end
HoneyComb(dims::NTuple{2, Int}, boundary::AbstractBoundary=Periodic) = HoneyComb(dims, ntuple(x->boundary, 2))
HoneyComb(dims::NTuple{2, Int}, bcs=Periodic) = HoneyComb(dims, bcs)
