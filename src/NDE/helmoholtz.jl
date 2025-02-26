using GLMakie

## 椭圆型偏微分方程数值解求解 (b² - 4ac < 0)
# ∇²u(x, y) + g(x, y)u(x, y) == f(x, y)
# become Possion Equation when g(x, y) = 0 
# become Laplace Equation when g(x, y) = 0 and f(x, y) = 0

# u(x, y) defined on a rectangular domain [a, b] × [c, d]
# with boundary conditions: b(x), b(y)

## three point difference method
# Δx = (xₕ - xₗ)/Mₓ 
# Δy = (yₕ - yₗ)/My
# in domain [a, b] × [c, d] (Mₓ - 1) × (My - 1) Equations


function Helmholtz(
    g::Function,
    f::Function,
    b_x0::Function,
    b_xf::Function,
    b_y0::Function,
    b_yf::Function,
    x_bounds::Vector{Float64},
    y_bounds::Vector{Float64},
    N::Int64,
    M::Int64,
    max_iters::Int64,
    min_error::Float64
)
    # define grid points and boundary conditions
    U = zeros(N + 1, M + 1)  # u(x, y) on grid points
    F = zeros(N + 1, M + 1)  # f(x, y) on grid points
    G = zeros(N + 1, M + 1)  # g(x, y) on grid points

    a, b = x_bounds
    c, d = y_bounds
    Δx = (b - a) / N
    Δy = (d - c) / M
    x = range(a, stop=b, length=N + 1)
    y = range(c, stop=d, length=M + 1)

    origin_val = 0.0
    ### x axis bounds
    for i in axes(U, 1)
        U[i, 1] = b_x0(x[i])  # left
        U[i, M+1] = b_xf(x[i])  # right
        origin_val += (U[i, 1] + U[i, M+1])
    end

    ### y axis bounds
    for j in axes(U, 2)
        U[1, j] = b_y0(y[j])  # top
        U[N+1, j] = b_yf(y[j])  # bottom
        origin_val += (U[1, j] + U[N+1, j])
    end

    ### solve the system of equations using finite differences
    origin_val /= (2 * (N + M - 2)) # average value at the origin
    U[2:N, 2:M] .= origin_val
    for j in 1:M, i in 1:N
        F[i, j] = f(x[i], y[j])
        G[i, j] = g(x[i], y[j])
    end

    dx2 = Δx^2
    dy2 = Δy^2
    dxy2 = 2(Δx^2 + Δy^2)
    rx = dx2 / dxy2
    ry = dy2 / dxy2
    rxy = rx * dy2

    U_old = copy(U)
    for _ in 1:max_iters
        for j in 2:M-1, i in 2:N-1
            U[i, j] = ry * (U[i, j+1] + U[i, j-1]) + rx * (U[i+1, j] + U[i-1, j]) + rxy * (G[i, j] * U[i, j] - F[i, j])
        end
        if maximum(abs, (U .- U_old)) < min_error
            break
        end
        U_old = copy(U)
    end

    return U, x, y
end


## test example

f(x, y) = x^2 + y^2
g(x, _) = sqrt(abs(x))
x_bounds = [0, 4.0]
y_bounds = [0, 4.0]
N = 30
M = 30
b_x0(y) = y^2
b_xf(y) = 16 * cos(y)
b_y0(x) = x^2
b_yf(x) = 16 * cos(x)
max_iters = 500
min_error = 1e-5


result, x, y = Helmholtz(
    g,
    f,
    b_x0,
    b_xf,
    b_y0,
    b_yf,
    x_bounds,
    y_bounds,
    N, M,
    max_iters, min_error
)


begin
    fig = Figure()
    ax = Axis3(fig[1, 1])
    surface!(ax, x, y, result,
        interpolate=false, shading=NoShading,transparency=true)
    # scale!(ax, 1, 1, 0.5)
    fig
end


