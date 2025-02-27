using LinearAlgebra
using Distributions


"""
    py_metropolis(μ, Σ; Σ_prop=I, N=10^6)

an metropolis_hastings algorithm origin from python script
"""
function py_metropolis(μ, Σ; Σ_prop=I, N=10^6)
    xx_all = zeros(2, N)
    proposal = zeros(N)

    xx_all[:, 1] = rand(Uniform(-10,10),2)
    proposal[1] = pdf(MvNormal(μ, Σ), xx_all[:, 1])

    n_acc = 0
    n_all = 0
    ### start sampling
    for i in 1:N-1
        ## the proposal quantity from the proposal distribution
        xx = rand(MvNormal(xx_all[:, i], Σ_prop), 1) |> vec
        p1 = pdf(MvNormal(μ, Σ), xx)

        r0 = p1 / proposal[i]

        if rand() < r0
            xx_all[:, i+1] = xx
            proposal[i+1] = p1
            n_acc += 1
        else
            xx_all[:, i+1] = xx_all[:, i]
            proposal[i+1] = proposal[i]
        end
        n_all += 1
    end
    println("the acceptance rate of this chain is $(n_acc/n_all)")
    return xx_all
end


