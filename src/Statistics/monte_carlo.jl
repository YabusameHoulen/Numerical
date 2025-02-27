### simulation of pi
function pipi(n)
    counts = 0
    for (x, y) in zip(rand(n), rand(n))
        if x^2 + y^2 <= 1
            counts += 1
        end
    end
    counts / n * 4
end

@time pipi(200000000)


### Buffon's needle problem
function pfpi(n_test::Integer)
    needle_len = 0.8
    repeat = rand(n_test)
    angle_repeat = rand(n_test)
    x = @. 0.5 * repeat ## needle center to origin
    y = @. needle_len / 2 * sin(2π * angle_repeat)
    z = x .<= y
    n_test * needle_len ./ sum(z)
end

pfpi(10^7)


### skew and kurt of Beta distribution
using Distributions
let 
    samples = rand(Beta(5,10),10000)
    u = (samples.-mean(samples))./std(samples)
    skew = mean(u.^3)
    kurt = mean(u.^4) .- 3
    skew,kurt
end

