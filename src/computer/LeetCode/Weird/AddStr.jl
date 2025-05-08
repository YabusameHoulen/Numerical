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
        push!(str, appendstr[Int(this)+1])
    end
    return str |> reverse! |> join
end



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

Mytest(:BenchmarkTools) do
    @eval begin 
        @btime count_one(40)
        @btime count_one_v2(400000)
        @btime count_one_v3(400000)
        @btime count_one_v4(400000)
        @info " @btime to test performance"
    end
end
