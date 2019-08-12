struct Plane{BC <: BoundaryCond, N, TCell <: AbstractUnitCell{N}} <: AbstractLattice{N}
    shape::NTuple{N, Int}
    cells::TCell
end

shape(x::Plane) = x.shape
cell(x::Plane) = x.cells

# move to base
cell(x::SiteIt) = cell(x.lattice)
shape(x::SiteIt) = shape(x.lattice)

struct ItDim{D, I}
    it::I
end

sites(l::Plane{Periodic, N}) where N = Iterators.product(ntuple(k->ItDim(SiteIt(l), k), N)...)

function Base.iterate(it::SiteIt{Plane{Periodic, N}}, st::Int) where N
    
end

function iterate_sites(it::SiteIt{Plane{Periodic, N}}, cell_it, st) where N
    iterate(cell_it, )
end

@inline function iterate_dim(it::SiteIt{Plane{Periodic, N}}, dim::Int, st=1) where N
    

    cell_it = sites(cell(it))
    if st === ()
        s, cell_st = iterate_dim(cell_it, dim)
        return s, (cell_st, 2)
    else
        cell_st, ltc_st = st
        ltc_st > it.shape[dim] && return nothing
        
        st = iterate_dim(cell_it, dim, cell_st)
        if st === nothing
            s, cell_st = iterate_dim(cell_it, dim)
            return s, (cell_st, ltc_st + 1)
        end
        return s, (cell_st, ltc_st+1)
    end
end