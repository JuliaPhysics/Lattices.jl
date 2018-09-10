# Lattice.jl

A library for defining lattices in Julia. (work in progress)

## Install

This package is not registered yet. Please install it with `dev` in package mode:

```
pkg> dev https://github.com/Roger-luo/Lattices.jl.git
```

or just clone it and run with `julia --project`:

```sh
$ cd Lattice.jl
$ julia --project
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

## License

Apache License Version 2.0
