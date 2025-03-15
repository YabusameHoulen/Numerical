function bisec(func::Function, x_low::T, x_up::T; limit::T) where {T<:AbstractFloat}
    while abs(x_up - x_low) > limit
        # @info "iterate"
        x_mid = (x_up + x_low) / 2
        func(x_mid) > 0 ? x_up = x_mid : x_low = x_mid
    end
    return (x_low, x_up)
end

f(x) = x^3 - 6
@time bisec(f, 0.0, 10.0, limit=1e-20)

bisec(x -> x^5 + 2x^3 - 5x - 2, 0.0, 2.0, limit=1e-5)


function newtonMethod(f::Function, fprime::Function, x0, alpha, N)
    for k = 1:N
        x = x0 - f(x0) / fprime(x0)
        if abs(f(x)) < alpha || abs(x - x0) < alpha
            return println("Root: $x; Iteration number: $k")
        end
        x0 = x
    end
    y = f(x)
    println("Newton does not converge: current $x with function
    value $y")
end

newtonMethod(x -> x^2 - 5, x -> 2 * x, 5, 10^(-5), 20)
newtonMethod(x -> x^5 + 2x^3 - 5x - 2, x -> 5x^4 + 6x^2 - 5, 5, 1e-5, 20)

