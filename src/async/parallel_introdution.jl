using BenchmarkTools
## @threads
g(n) = sum([exp(1 / (1 + j^2)) for j in 1:n])

Threads.nthreads()

sequential_time = @belapsed for n in 90_000:100_000
    res = g(n)
end

parallel_time = @belapsed Threads.@threads for n in 90_000:100_000
    res = g(n)
end

## parallel_sum_with_lock
function parallel_sum_with_lock(n)
    result = Threads.Atomic{Float64}(0.0)
    Threads.@threads for i in 1:n
        Threads.atomic_add!(result, g(i))
    end
    return result[]
end

parallel_sum_with_lock(500)
parallel_sum_with_lock(500)
parallel_sum_with_lock(500)

## Distributed
using BenchmarkTools
using Distributed

# addprocs 
if workers() == procs()
    addprocs(2)
end

@everywhere begin
    g(n) = g(n) = sum([exp(1 / (1 + j^2)) for j in 1:n])
end

parallel_time = @belapsed @sync @distributed for n in 90_000:100_000
    res = g(n)
end


