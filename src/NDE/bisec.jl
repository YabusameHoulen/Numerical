function bisec(func::Function, x_low::T, x_up::T; limit::T) where {T<:AbstractFloat}
    while (x_up - x_low)*(x_up-x_low) > limit
        x_mid = (x_up + x_low) / 2
        func(x_mid) > 0 ? x_up = x_mid : x_low = x_mid
    end
    return (x_low, x_up)
end

f(x) = x^3 - 6
@time bisec(f, 0.0, 10.0, limit=1e-20)

bisec(x -> x^5+2x^3-5x-2,0.0,2.0, limit=1e-20)