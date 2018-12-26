export sites, edges, surround, faces, neighbors

# This file defines the interface of a lattice iterator
# All lattice iterators are duck-typed

"""
    sites(lattice) -> iterator

Returns an iterator for all sites on the lattice.
"""
function sites end

"""
    edges(lattice; [length=1]) -> iterator

Returns an iterator for all edges of `length` on the lattice.
"""
function edges end

"""
    surround(lattice) -> iterator

Returns an iterator of surroundings of all sites.

    surround(lattice, site) -> iterator

Returns an iterator of surrounding sites of given `site`.
"""
function surround end

"""
    faces(lattice) -> iterator

Returns an iterator of all faces.
"""
function faces end

"""
    neighbors(lattice, s; length=1) -> iterator

Returns an iterator of the surrounding sites of given site `s`.
"""
function neighbors end
