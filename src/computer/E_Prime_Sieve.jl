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
    @inbounds for i in 2:n
        numbers[i] == true && (push!(primes, i))
        for j in primes
            numbers[i*j] = false
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
prime_sieve_Eratosthenes(1000)
prime_sieve_Eratosthenes(1000) .|> primeQ |> all


@code_warntype prime_sieve_Euler(1000)
@code_warntype prime_sieve_Eratosthenes(100000)

@time prime_sieve_Euler(1000000000)
@time prime_sieve_Eratosthenes(100000000)

# using Test

# @testset "Trigonometric identities" begin
#     x = 2 / 3 * π
#     @test sin(-x) ≈ -sin(x)
#     @test cos(-x) ≈ -cos(x)
#     @test sin(2x) ≈ 2 * sin(x) * cos(x)
#     @test cos(2x) ≈ cos(x)^2 - sin(x)^2
# end;

# @test prime_sieve_Eratosthenes(100) == prime_sieve_Euler(100)