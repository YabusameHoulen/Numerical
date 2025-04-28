using Optim

# 定义 Profile Likelihood
function profile_likelihood(S, N, μ_B, σ_B)
    obj(B) = - (N * log(S + B) - (S + B) - ((B - μ_B)^2) / (2 * σ_B^2))
    result = optimize(obj, μ_B)  # 以 μ_B 作为初始猜测值
    return -minimum(result)
end

# 示例参数
N = 20
μ_B = 10
σ_B = 3
S_values = 0:0.1:50
L_p_values = [profile_likelihood(S, N, μ_B, σ_B) for S in S_values]

# 绘制 Profile Likelihood
using GLMakie
fig = Figure()
ax = Axis(fig[1,1], title="Profile Likelihood", xlabel="S", ylabel="Log Likelihood")
lines!(ax, S_values, L_p_values)
display(fig)
