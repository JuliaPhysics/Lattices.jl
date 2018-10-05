var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "#Welcome-to-the-documentation-of-Lattice.jl-1",
    "page": "Introduction",
    "title": "Welcome to the documentation of Lattice.jl",
    "category": "section",
    "text": "This is a Julia package for defining lattices in Julia.All lattice type in this package is duck typed. Any Julia type with the (Geometric) Region/Lattice Interface can be considered as a (geometric) region/lattice."
},

{
    "location": "#Interfaces-1",
    "page": "Introduction",
    "title": "Interfaces",
    "category": "section",
    "text": ""
},

{
    "location": "#Conversion-between-lattice-position-and-serial-number-1",
    "page": "Introduction",
    "title": "Conversion between lattice position and serial number",
    "category": "section",
    "text": ""
},

{
    "location": "#Site-iterator-1",
    "page": "Introduction",
    "title": "Site iterator",
    "category": "section",
    "text": "function: sites"
},

{
    "location": "#Edge-iterator-1",
    "page": "Introduction",
    "title": "Edge iterator",
    "category": "section",
    "text": "function: edges"
},

{
    "location": "#Surround-iterator-(Optional)-1",
    "page": "Introduction",
    "title": "Surround iterator (Optional)",
    "category": "section",
    "text": "function: surround"
},

{
    "location": "#Face-iterator-(Optional)-1",
    "page": "Introduction",
    "title": "Face iterator (Optional)",
    "category": "section",
    "text": "function: faces"
},

{
    "location": "#Lattices.BoundedLattice",
    "page": "Introduction",
    "title": "Lattices.BoundedLattice",
    "category": "type",
    "text": "BoundedLattice{N, BC} <: AbstractLattice{N}\n\nA lattice with boundary conditions BC on N dimension.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.Fixed",
    "page": "Introduction",
    "title": "Lattices.Fixed",
    "category": "type",
    "text": "Fixed <: BoundaryCondition\n\nFixed boundary condition.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.Periodic",
    "page": "Introduction",
    "title": "Lattices.Periodic",
    "category": "type",
    "text": "Periodic <: BoundaryCondition\n\nPeriodic boundary condition.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.boundary",
    "page": "Introduction",
    "title": "Lattices.boundary",
    "category": "function",
    "text": "boundary(lattice) -> BoundaryCondition\n\nReturns lattice\'s boundary condition.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.edges",
    "page": "Introduction",
    "title": "Lattices.edges",
    "category": "function",
    "text": "edges(lattice; [length=1]) -> iterator\n\nReturns an iterator for all edges of length on the lattice.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.faces",
    "page": "Introduction",
    "title": "Lattices.faces",
    "category": "function",
    "text": "faces(lattice) -> iterator\n\nReturns an iterator of all faces.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.isperiodic",
    "page": "Introduction",
    "title": "Lattices.isperiodic",
    "category": "function",
    "text": "isperiodic(lattice) -> Bool\n\nCheck if this lattice\'s boundary condition is periodic.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.sites",
    "page": "Introduction",
    "title": "Lattices.sites",
    "category": "function",
    "text": "sites(lattice) -> iterator\n\nReturns an iterator for all sites on the lattice.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.surround",
    "page": "Introduction",
    "title": "Lattices.surround",
    "category": "function",
    "text": "surround(lattice) -> iterator\n\nReturns an iterator of surroundings of all sites.\n\nsurround(lattice, site) -> iterator\n\nReturns an iterator of surrounding sites of given site.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.AbstractLattice",
    "page": "Introduction",
    "title": "Lattices.AbstractLattice",
    "category": "type",
    "text": "AbstractLattice{N}\n\nAbstract type for general lattices. N indicates the dimension. For a more concrete definition please refer the following material:\n\nLattice (group): https://en.wikipedia.org/wiki/Lattice_(group)\nLattice Model: https://en.wikipedia.org/wiki/Latticemodel(physics)\nLattice Graph: https://en.wikipedia.org/wiki/Lattice_graph\n\n\n\n\n\n"
},

{
    "location": "#Lattices.BoundaryCondition",
    "page": "Introduction",
    "title": "Lattices.BoundaryCondition",
    "category": "type",
    "text": "BoundaryCondition\n\nBoundary conditions for lattices. There usually has two:\n\n- Fixed boundary\n- Periodic boundary\n\nRef: https://nanohub.org/resources/7577/download/MartiniL5BoundaryConditions.pdf\n\n\n\n\n\n"
},

{
    "location": "#Base.length",
    "page": "Introduction",
    "title": "Base.length",
    "category": "function",
    "text": "length(lattice) -> Int\n\nReturns the length of this lattice, or the production of each dimension size.\n\n\n\n\n\n"
},

{
    "location": "#Base.nameof-Tuple{Lattices.AbstractLattice}",
    "page": "Introduction",
    "title": "Base.nameof",
    "category": "method",
    "text": "name(lattice) -> String\n\nReturns the name of this lattice.\n\n\n\n\n\n"
},

{
    "location": "#Base.ndims-Union{Tuple{AbstractLattice{N}}, Tuple{N}} where N",
    "page": "Introduction",
    "title": "Base.ndims",
    "category": "method",
    "text": "ndims(lattice) -> N\n\nReturns number of dimensions of the lattice.\n\n\n\n\n\n"
},

{
    "location": "#Base.size",
    "page": "Introduction",
    "title": "Base.size",
    "category": "function",
    "text": "size(lattice) -> Tuple\n\nReturns the size of this lattice.\n\n\n\n\n\n"
},

{
    "location": "#Lattices.fastmod1-Union{Tuple{X}, Tuple{Y}, Tuple{Val{X},Val{Y}}} where X where Y",
    "page": "Introduction",
    "title": "Lattices.fastmod1",
    "category": "method",
    "text": "fastmod1(::Val{X}, ::Val{Y})\n\nmod1 in compile time, 40x faster if the value can be determined\n\n\n\n\n\n"
},

{
    "location": "#Lattices-1",
    "page": "Introduction",
    "title": "Lattices",
    "category": "section",
    "text": "Modules = [Lattices]\nOrder   = [:type, :function]"
},

]}
