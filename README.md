# Lattices.jl

[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://juliaphysics.github.io/Lattices.jl)
[![travis][travis-img]](https://travis-ci.org/JuliaPhysics/Lattices.jl)
[![license: MIT](https://img.shields.io/badge/License-MIT-red.svg)](https://opensource.org/licenses/MIT)
![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)

[travis-img]: https://img.shields.io/travis/JuliaPhysics/Lattices.jl/master.svg?label=Linux%20/%20MacOS

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
