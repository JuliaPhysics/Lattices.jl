# Lattice.jl

[![Build Status](https://travis-ci.org/Roger-luo/Lattices.jl.svg?branch=master)](https://travis-ci.org/Roger-luo/Lattices.jl)

A library for defining lattices in Julia.

## Install

**NOTE**: only supports Julia v1.0+.

```
pkg> add Lattices
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

julia> for (a, b) in edges(l, length=2)
          # do something on edges

          println("this is point a: ", a)
          println("this is point b: ", b)
       end
```

## TODO

- [ ] Site Type

- [ ] Hexagonel Lattice
- [ ] Triangular Lattice

## License

Apache License Version 2.0
