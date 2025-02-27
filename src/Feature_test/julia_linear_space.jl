using CanonicalTraits

function vect_eltype_infer end
@trait Vect{F,V} where {F=vect_infer_helper(V)} begin
    scalar_mul::[F, V] => V
    scalar_div::[V, F] => V

    vec_add::[V, V] => V
    vec_sub::[V, V] => V

    scalar_add::[F, V] => V
    scalar_sub::[V, F] => V

    scalar_div(vec::V, scalar::F) = scalar_mul(one(F) / scalar, vec)
    scalar_sub(vec::V, scalar::F) = scalar_add(-scalar, vec)
    vec_sub(vec1::V, vec2::V) = vec_add(vec1, scalar_mul(-one(F), vec2))
end


vect_infer_helper(::Type{Tuple{F,F}}) where {F<:Number} = F
@implement Vect{F,Tuple{F,F}} where {F<:Number} begin
    scalar_add(num, vec) =
        (vec[1] + num, vec[2] + num)
    vec_add(vec1, vec2) =
        (vec1[1] + vec2[1], vec1[2] + vec2[2])
    scalar_mul(num, vec) =
        (num * vec[1], num * vec[2])
end


vec_add((3, 4), (5, 6))
scalar_mul(3, (4, 5))
scalar_mul(3, [4, 5])

## Flexible instance and Flexible Classes
using CanonicalTraits

@trait Add1{T<:Number} begin
    add1::[T] => T
end

@trait Add1{T} >: Addn{T<:Number} begin
    addn::[Int, T] => T
    addn(n, x) =
        let s = x
            for i in 1:n
                s = add1(s)
            end
            s
        end
end

@implement Add1{Int} begin
    add1(x) = x + 1
end
@implement Addn{Int}
@implement! Add1{T} >: Add1{Vector{T}} where {T} begin
    add1(xs) = add1.(xs)
end

addn(4, 2)

add1([1, 2])

## Gram-Schmidt Orthogonalization
using CanonicalTraits

function scalartype_of_vectorspace end
@trait Vect{F<:Number,V} where
{F=scalartype_of_vectorspace(V)} begin
    vec_add::[V, V] => V
    scalar_mul::[F, V] => V
end

@trait InnerProduct{F<:Number,V} where
{F=scalartype_of_vectorspace(V)} begin
    dot::[V, V] => F
end

function gram_schmidt!(v::V, vs::Vector{V})::V where {V}
    for other in vs
        coef = dot(v, other) / dot(other, other)
        incr = scalar_mul(-coef, other)
        v = vec_add(v, incr)
    end
    magnitude = sqrt(dot(v, v))
    scalar_mul(1 / magnitude, v)
end

scalartype_of_vectorspace(::Type{Vector{Float64}}) = Real
@implement! InnerProduct{T,Vector{Float64}} where {T<:Real} begin
    dot(a, b) = sum(a .* b)
end
@implement! Vect{T,Vector{Float64}} where {T<:Real} begin
    vec_add(x, y) = x .+ y
    scalar_mul(a, x) = a .* x
end

gram_schmidt!([1.0, 1, 1], [[1.0, 0, 0], [0, 1.0, 0]])