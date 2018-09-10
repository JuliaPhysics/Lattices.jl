export Periodic, Fixed

"""
    BoundaryCondition

Boundary conditions for lattices. There usually has two:

    - Fixed boundary
    - Periodic boundary

Ref: https://nanohub.org/resources/7577/download/Martini_L5_BoundaryConditions.pdf
"""
abstract type BoundaryCondition end


"""
    Periodic <: BoundaryCondition

Periodic boundary condition.
"""
abstract type Periodic <: BoundaryCondition end

"""
    Fixed <: BoundaryCondition

Fixed boundary condition.
"""
abstract type Fixed <: BoundaryCondition end
