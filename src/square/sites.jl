Lattices.sites(lattice::Square) = SitesIterator(lattice)

struct SitesIterator{Shape}
    SitesIterator(ltc::Square{S}) where S = new{S}()
end

function Base.iterate(it::SitesIterator{Tuple{height, width}}, state = (1, 1, 1)) where {height, width}
    i, j, count = state

    if count == length(it) + 1
        return nothing
    elseif i > height
        return (1, j+1), (2, j+1, count+1)
    else
        return (i, j), (i+1, j, count+1)
    end
end

Base.size(::SitesIterator{Tuple{H, W}}) where {H, W} = (H, W)
Base.length(::SitesIterator{Tuple{height, width}}) where {height, width} = width * height
Base.eltype(::SitesIterator) = SiteType
