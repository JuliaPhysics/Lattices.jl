struct LessEqual{L, T <: Integer} <: Integer
    val::T

    LessEqual{L}(x::T) where {L, T} = new{L, T}(x)
end


import Base: +
addone(x::LessEqual{L}) where L = x.val == L ? LessEqual{L}(1) : LessEqual{L}(x + 1)
+(lhs::LessEqual{L}, rhs::Integer) where L = rhs == 1 ? addone(lhs) : LessEqual{L}(lhs.val + rhs)

"""
    fastmod1(::Val{X}, ::Val{Y})

`mod1` in compile time, 40x faster if the value can be determined
"""
@generated fastmod1(::Val{X}, ::Val{Y}) where X where Y =
    X == 0   ? Y :
    X <= Y   ? X :
    X == Y+1 ? 1 :
    X == Y+2 ? 2 :
    mod1(X, Y)
