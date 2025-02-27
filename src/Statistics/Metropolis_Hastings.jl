using Distributions
using LinearAlgebra

μ = [3.0, 0.0]
ρ = 0.9 ### a scale constant
Σ = [1.0 ρ√2; ρ√2 2.0]

### generate random number from 2D normal distribution
dist = MvNormal(μ, Σ)
data_points = rand(dist, 3000)
### create a 2d histogram for the gauess distribution
# using StatsPlots
# plotly()
# histogram2d(x, y, bins=(30, 30), show_empty_bins=true,
#     normalize=:pdf, weights=data_points, color=:plasma)
# Z = [pdf(dist,[i,j]) for j in y, i in x] ### plot in StatsPlots
# plot(x,y,Z,st=:surface)
using GLMakie
x = range(-5, 5, 100)
y = range(-5, 5, 100)
Z = [pdf(dist, [i, j]) for i in x, j in y] ### plot in GLMakie
contourf(x, y, Z)
scatter(data_points)
wireframe(data_points)

### algorithm of metropolis_hastings

function Metropolis(dist ; sample_num=10^6)
    prior(lam) = pdf(Gamma(alpha, 1 / beta), lam)
    like(lam) = ([pdf(Poisson(lam), x) for x in data]...)
    posteriorUpToK(lam) = like(lam) * prior(lam)

    lam = 1
    burn_in = sample_num ÷ 10
    samples = zeros(sample_num - burn_in)

    for t in 1:sample_num
        while true
            lamTry = abs(rand(Normal(mu, sig)))

        end
    end

end

chain = py_metropolis(μ, Σ)

lines(chain)
scatter(chain)


function sampler(piProb, qProp, rvProp)
    lam = 1
    warmN, N = 10^5, 10^6
    samples = zeros(N - warmN)

    for t in 1:N
        while true
            lamTry = rvProp(lam)
            L = piProb(lamTry) / piProb(lam)
            H = min(1, L * qProp(lam, lamTry) / qProp(lamTry, lam))
            if rand() < H
                lam = lamTry
                if t > warmN
                    samples[t-warmN] = lam
                end
                break
            end
        end
    end
    return samples
end

