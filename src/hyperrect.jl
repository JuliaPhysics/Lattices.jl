export HyperRect

"""
    HyperRect{N, Shape, BC} <: BoundedLattice{N, BC}

Hyper Rectangle lattice on `N` dimension with size `Shape`.
"""
struct HyperRect{N, BC, Shape <: Tuple} <: BoundedLattice{N, BC}
end

HyperRect(shape::Int...; boundary=Periodic) = HyperRect(shape; boundary=boundary)
HyperRect(shape::NTuple{N, Int}; boundary=Periodic) where N = HyperRect{N, boundary, Tuple{shape...}}()
nameof(::HyperRect{N}) where N = "HyperRect{$N}"
Base.@pure Base.size(::HyperRect{N, BC, Shape}) where {N, BC, Shape} = tuple(Shape.parameters...)

function sites(ltc::HyperRect)
    Base.CartesianIndices((Base.OneTo(k + 1) for k in size(ltc))...)
end

function edges(ltc::HyperRect; order=1)
    error("Not Implemented Yet")
end

function neighbors(::HyperRect{N, Periodic, Shape}, P::CartesianIndex; order=1) where {N, Shape}
    @boundscheck all(x->x>0, Tuple(P)) || error("Lattice configuration position starts from 1")
    hyper_rect_neighbors(P, Shape, Val(length))
end

# NOTE: we assume HyperRect lattice only work for low dimension case, therefore
#       we will unroll the neighbors iterator to a tuple directly.
@generated function hyper_rect_neighbors(P::CartesianIndex{D}, L::Type{Shape}, ::Val{len}) where D where {Shape <: Tuple, len}
    ex = Expr(:tuple)

    for i in 1:D
        push!(ex.args, gen_cartesian_nn_index_expr(:P, D, i, Shape.parameters[i], len))
        push!(ex.args, gen_cartesian_nn_index_expr(:P, D, i, Shape.parameters[i], -len))
    end
    ex
end

function gen_cartesian_nn_index_expr(P::Symbol, D::Int, i::Int, L::Int, k::Int)
    ind_ex = Expr(:call, :CartesianIndex)
    for index in 1:D
        if index == i
            push!(ind_ex.args, :(mod1($P[$index] + $k, $(L + 1))))
        else
            push!(ind_ex.args, :($P[$index]))
        end
    end
    ind_ex
end
