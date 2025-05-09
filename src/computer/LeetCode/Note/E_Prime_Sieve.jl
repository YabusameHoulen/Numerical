function prime_sieve_Eratosthenes(n::Integer)
    numbers = trues(n)
    numbers[1] = false
    @inbounds for i in 2:floor(Int, sqrt(n))
        numbers[i] == false && continue
        for j in i^2:i:n
            numbers[j] = false
        end
    end
    findall(numbers)
end

function prime_sieve_Euler(n::Integer)
    numbers = trues(n)
    primes = Int[]
    for i in 2:n
        numbers[i] == true && (push!(primes, i))
        for j in primes
            if i * j <= n
                numbers[i*j] = false
            end
            i % j == 0 && break
        end
    end
    primes
end

function primeQ(n::Int)
    n <= 3 && return n > 1
    !in(n % 6, [1, 5]) && return false
    for i in 5:6:floor(Int, sqrt(n))
        (n % i == 0 || n % (i + 2) == 0) && return false
    end
    return true
end

@testitem "Prime" begin
    # using BenchmarkTools
    using Algorithms: prime_sieve_Eratosthenes, prime_sieve_Euler, primeQ
    @test prime_sieve_Eratosthenes(10000) == prime_sieve_Euler(10000)
    @test prime_sieve_Eratosthenes(1000) .|> primeQ |> all
    # @btime prime_sieve_Eratosthenes(1000)
end