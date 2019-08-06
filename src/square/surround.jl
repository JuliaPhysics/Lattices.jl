struct SurroundSiteIterator{Shape, BC, K}
    site::Tuple{Int, Int}
end

Lattices.surround(lattice::Square{S, BC}, site; order::Int=1) where {S, BC} = SurroundSiteIterator{S, BC, order}(site)
Base.eltype(::SurroundSiteIterator) = SiteType
Base.length(::SurroundSiteIterator{<:Tuple, Periodic}) = 4

function _iterate_odd(it::SurroundSiteIterator{Tuple{h, w}, Periodic}, K, state) where {h, w}
    x, y = it.site
    state == 1 ? ((mod1(x + K, h), y), 2) :
    state == 2 ? ((x, mod1(y + K, w)), 3) :
    state == 3 ? ((mod1(x - K, h), y), 4) :
    state == 4 ? ((x, mod1(y - K, w)), 5) :
    nothing
end

function _iterate_even(it::SurroundSiteIterator{Tuple{h, w}, Periodic}, K, state) where {h, w}
    x, y = it.site
    state == 1 ? ((mod1(x + K, h), mod1(y + K, w)), 2) :
    state == 2 ? ((mod1(x - K, h), mod1(y + K, w)), 3) :
    state == 3 ? ((mod1(x - K, h), mod1(y - K, w)), 4) :
    state == 4 ? ((mod1(x + K, h), mod1(y - K, w)), 5) :
    nothing
end

@generated function Base.iterate(it::SurroundSiteIterator{<:Tuple, Periodic, K}, state=1) where K
    isodd(K) ? :(_iterate_odd(it, $(div(K, 2) + 1), state)) :
    :(_iterate_even(it, $(div(K, 2)), state))
end

function _iterate_odd(it::SurroundSiteIterator{Tuple{h, w}, Fixed}, K, state) where {h, w}
    x, y = it.site
    if (K < x < h - K + 1) && (K < y < w - K + 1)
        state == 1 ? ((x + K, y), 2) :
        state == 2 ? ((x, y + K), 3) :
        state == 3 ? ((x - K, y), 4) :
        state == 4 ? ((x, y - K), 5) :
        nothing
    elseif x == K
        if y == K
            state == 1 ? ((x + K, y), 2) :
            state == 2 ? ((x, y + K), 3) :
            nothing
        else
            state == 1 ? ((x + K, y), 2) :
            state == 2 ? (())
        end
        state == 1 ? (x + 1)
    elseif y == 1 || y == w
    end
end

function Base.iterate(it::SurroundSiteIterator{Tuple{h, w}, Fixed, K}, state=1) where {h, w}
    x, y = it.site
    if 1 < x < h && 1 < y < w
        state == 1 ? (x + 1, y), 2 :
        state == 2 ? (x, y + 1), 3 :
        state == 3 ? (x - 1, y), 4 :
        state == 4 ? (x, y - 1), 5 :
        nothing
    elseif x == h
        if 1 < y < w
            state == 1 ? (x, y + 1), 2 :
            state == 2 ? (x, y + 1), 3 :
            nothing
        elseif y == 1 || y == w
            state == 1 ? (x, y) :
            nothing
        end
    end
end
