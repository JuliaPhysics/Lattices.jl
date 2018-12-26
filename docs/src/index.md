# Welcome to the documentation of Lattice.jl

This is a Julia package for defining lattices in Julia.

All lattice type in this package is **duck typed**. Any Julia type
with the **(Geometric) Region/Lattice Interface** can be considered as a (geometric)
region/lattice.

## Interfaces

#### Conversion between lattice position and serial number

#### Site iterator

**function**: [`sites`](@ref)

#### Edge iterator

**function**: [`edges`](@ref)

#### Surround iterator (Optional)

**function**: [`surround`](@ref)

#### Face iterator (Optional)

**function**: [`faces`](@ref)

#### Neighbor sites iterator (Optional)

**function** [`neighbors`](@ref)

## Lattices

```@autodocs
Modules = [Lattices]
Order   = [:type, :function]
```
