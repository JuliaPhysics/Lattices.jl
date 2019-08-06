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
                                    
julia> for (from, to) in edges(l)   
           println(from, " -> ", to)
       end                          
1 -> 2                              
2 -> 3                              
3 -> 4                              
4 -> 1                              
```

## TODO

- [ ] Site Type

- [ ] Hexagonel Lattice
- [ ] Triangular Lattice

## License

Apache License Version 2.0
