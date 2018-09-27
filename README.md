# Lattice.jl

A library for defining lattices in Julia.

## Install

```
pkg> add https://github.com/Roger-luo/Lattices.jl.git
```

## A glance of the interface

```julia-repl
julia> using Lattice

julia> l = chain(4)
Chain Lattice:
  Periodic boundary
  size: (4,)

julia> for each in sites(l)
          # do something on sites
          @show each
       end

each = 1
each = 2
each = 3
each = 4
```

## TODO

- [ ] Hexagonel Lattice
- [ ] Triangular Lattice

## License

Apache License Version 2.0
