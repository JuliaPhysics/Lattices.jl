# Lattices.jl

[![Build Status](https://travis-ci.org/JuliaPhysics/Lattices.jl.svg?branch=master)](https://travis-ci.org/JuliaPhysics/Lattices.jl)
![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

A library for defining lattices in Julia.

**Warning**: This package is still at very early stage for exploring a potential Julian interface for lattices. Take your own risk of using the package, and please feel free to join the discussions in the issues and PRs.

## Install

```
pkg> add Lattices
```

## A glance of the interface

```julia-repl
julia> using Lattices               
                                    
julia> l = Chain(4)                 
Chain Lattice                       
boundary: Periodic                  
size:     (4,)                      
                                    
julia> for each in sites(l)         
           @show each               
       end                          
each = 1                            
each = 2                            
each = 3                            
each = 4                            
                                    
julia> for (a, b) in edges(l)   
           println(a, " <-> ", b)
       end                          
1 <-> 2                              
2 <-> 3                              
3 <-> 4                              
4 <-> 1                              
```

## TODO

- [ ] Site Type

- [ ] Hexagonel Lattice
- [ ] Triangular Lattice

## License

Apache License Version 2.0
