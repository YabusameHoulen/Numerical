fib_normal(n::Integer) = (BigInt.([1 1; 1 0])^n)[2]

fib(T::Int) = fib(Val(T))
fib(::Val{T}) where {T} = T <= 1 ? T  : fib(Val(T - 1)) + fib(Val(T - 2))
