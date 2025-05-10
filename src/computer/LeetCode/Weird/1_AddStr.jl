function addstr(str1::String, str2::String)::String
    str = Char[]
    appendstr = "01"
    temp = false
    for (i, j) in Iterators.reverse(zip(str1, str2))
        this = false
        if i == '1' && j == '1'
            if temp
                this = true
            else
                this = false
            end
            temp = true
        elseif i == '0' && j == '0'
            if temp
                this = true
            else
                this = false
            end
            temp = false
        else
            if temp
                this = false
                temp = true
            else
                this = true
                temp = false
            end
        end
        push!(str, appendstr[this+1])
    end
    return str |> reverse! |> join
end


### 前N个数中二进制位数有多少个1
function count_one(n::Integer)
    map(x -> sum(digits(x, base=2)), 0:n)
end

### 每次读写都是线性推进，非常 cache-friendly
function count_one_v2(n::Int)
    result = Vector{Int}(undef, n + 1)
    for i in 0:n
        j = i
        count = 0
        while j != 0
            j = j & (j - 1)
            count += 1
        end
        result[i+1] = count
    end
    return result
end

### 这个算法理论上更好，但对 CPU 缓存友好性更差
function count_one_v3(n::Int)
    result = Vector{Int}(undef, n + 1)
    result[1] = 0
    for i in 1:n
        result[i+1] = result[(i&(i-1))+1] + 1
    end
    return result
end


function count_one_v4(n::Int)
    result = Vector{Int}(undef, n + 1)
    result[1] = 0
    result[2] = 1
    for i in 2:n
        result[i+1] = result[(i>>1)+1] + (i & 1)
    end
    return result
end

# 输入一个字符串数组 words,请计算不包含相同字符的两个字符
# 串 words[i]和 words[j]的长度乘积的最大值
# 如果所有字符串都包含至少一个相同字符,那么返回 0
# 假设字符串中只包含英文小写字母。例如,输入的字符串数组 words 为
# ["abcw", "foo", "bar", "fxyz","abcdef"], 数组中的字符
# 串"bar"与"foo"没有相同的字符,它们长度的乘积为 9。"abcw"与"fxyz"也没
# 有相同的字符,它们长度的乘积为 16,这是该数组不包含相同字符的一对
# 字符串的长度乘积的最大值。

function multiply_string(arr::Vector{String})
    # mapping = Dict(k => v for (k, v) in zip('a':'z', @. 2^(0:25)))
    # numbermapping = similar(arr, Int64)
    # for i in eachindex(arr)
    #     num = 0
    #     for char in arr[i]
    #         num += mapping[char]
    #     end
    #     numbermapping[i] = num
    # end
    numbermapping = similar(arr, Int64)
    for i in eachindex(arr)
        num = 0
        for char in arr[i]
            num |= 1 << (char - 'a') ### |= 消除了单个字符串中的重复字符
        end
        numbermapping[i] = num
    end

    max_result = 0
    # safe_nextindex(x, i) = min(nextind(x, i), lastindex(x))
    indices = eachindex(numbermapping)
    for i in indices
        for j in Iterators.drop(indices, i)
            if numbermapping[i] & numbermapping[j] == 0
                max_result = max(length(arr[i]) * length(arr[j]), max_result)
            end
        end
    end
    return max_result
end

Mytest(:BenchmarkTools) do
    @eval begin
        @btime count_one(40)
        @btime count_one_v2(400000)
        @btime count_one_v3(400000)
        @btime count_one_v4(400000)
        @info " @btime to test performance"
    end
end

@testitem "Integer_String" begin
    using Algorithms: multiply_string
    @test multiply_string(["abcw", "foo", "bar", "fxyz", "abcdef"]) == 16
end
