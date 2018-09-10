export sites, edges

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
