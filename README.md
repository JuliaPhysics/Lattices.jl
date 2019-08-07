# Lattices.jl

[![Build Status](https://travis-ci.org/Roger-luo/Lattices.jl.svg?branch=master)](https://travis-ci.org/Roger-luo/Lattices.jl)

A library for defining lattices in Julia.

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
