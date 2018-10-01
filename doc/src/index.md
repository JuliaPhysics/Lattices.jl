# Welcome to the documentation of Lattice.jl

This is a Julia package for defining lattices in Julia.

All lattice type in this package is **duck typed**. Any Julia type
with the **(Geometric) Region/Lattice Interface** can be considered as a (geometric)
region/lattice.

## Interfaces

#### Site iterator

**function**: [`sites`](@ref)

#### Edge iterator

**function**: [`edges`](@ref)

#### Surround iterator (Optional)

**function**: `surround`

#### Face iterator (Optional)

**function**: `faces`

## Lattices

```@autodocs
Modules = [Lattices]
Order   = [:type, :function]
```
