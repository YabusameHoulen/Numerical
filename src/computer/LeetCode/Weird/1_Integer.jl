### 不使用除号的除法
function my_div(divident::Integer, divisor::Integer)
    ### 超出无符号整数范围
    if divident == -typemax(typeof(divident)) && divisor == -1
        return typemax(typeof(divident))
    end

    ### 正负符号
    minus_count = 2
    if divident > 0
        divident = -divident
        minus_count -= 1
    end
    if divisor > 0
        divisor = -divisor
        minus_count -= 1
    end
    result = div_core(divident, divisor)
    minus_count == 1 ? -result : result
end

function div_core(divident::Integer, divisor::Integer)
    result = 0
    while divident <= divisor
        value = divisor
        quotient = one(divisor)
        ### 防止整数溢出
        while value >= -0.5 * typemax(typeof(divident)) && divident <= value + value
            ### 指数增长
            quotient += quotient
            value += value
        end
        ### 累加倍数并减去
        result += quotient
        divident -= value
    end
    return result
end


### 重复出现数字的数组，查找元素
function integer_array_original(arr::Vector{T}) where {T<:Integer}
    N = length(bitstring(arr[begin]))
    @assert N in [8, 16, 32, 64, 128]
    result = zero(T)
    for num in arr
        result ⊻= num
    end
    return result
end


function integer_array(arr::Vector{T}) where {T<:Integer}
    N = sizeof(T) * 8
    @assert N in [8, 16, 32, 64, 128]
    num_bits = zeros(Int, N)
    for num in arr
        for i in 1:N
            num_bits[i] += (num >> (N - i)) & 1
        end
    end
    result = zero(T)
    for i in 1:N
        result = (result << 1) + num_bits[i] % 3
    end
    return result
end


# 输入一个整数数组,数组中只有一个数字出现 m 次,其他数字
# 都出现 n 次。请找出那个唯一出现 m 次的数字。假设 m 不能被 n 整除
function integer_array_general(arr::Vector{T}, m, n) where {T<:Integer}
    N = sizeof(T) * 8
    @assert N in [8, 16, 32, 64, 128]
    @assert m % n != 0 "m 不能被 n 整除"
    num_bits = zeros(Int, N)
    for num in arr
        for i in 1:N
            num_bits[i] += (num >> (N - i)) & 1
        end
    end
    result = zero(T)
    for i in 1:N
        # result = (result << 1) + (num_bits[i] % n) ÷ (m % n)
        # 避免除法会更快
        result = (result << 1) + (num_bits[i] % n != 0)
    end
    return result
end


@testitem "Integer_Array" begin
    using Algorithms: my_div, integer_array_original, integer_array, integer_array_general
    @test my_div(-15, 2) == -7
    @test integer_array_original([2, 2, 3, 3, 5, 4, 4, 5, 6]) == 6
    @test integer_array([1, 1, 1, 4, 2, 2, 2, 4, 4, 5]) == 5
    @test integer_array_general([1, 1, 1, 4, 2, 2, 2, 4, 4, 5, 5, 5, 5, 5], 5, 3) == 5
end

Mytest(:BenchmarkTools) do
    @eval begin
        @btime integer_array_general([1, 1, 1, 4, 2, 2, 2, 4, 4, 5, 5, 5, 5, 5], 5, 3)
        @info "practice"
    end
end