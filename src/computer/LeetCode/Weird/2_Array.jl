# 输入一个递增排序的数组和一个值 k, 请问如何在数组中找出两个和为 k 的数字并返回它们的下标?
# 假设数组中存在且只存在一对符合条件的数字, 同时一个数字不能使用两次
# 例如, 输入数组[1, 2, 4, 6, 10], k的值为 8, 数组中的数字 2 与 6 的和为 8, 它们的下标分别为 1 与 3
function find_indices(arr::Vector, target)
    i = firstindex(arr)
    j = lastindex(arr)
    while arr[i] + arr[j] != target
        arr[i] + arr[j] < target ? i = nextind(arr, i) : j = prevind(arr, j)
    end
    return i, j
end

function find_indices_fixed(arr::Vector, target)
    i = 1
    j = length(arr)
    while arr[i] + arr[j] != target
        arr[i] + arr[j] < target ? i += 1 : j -= 1
    end
    return i, j
end

# 输入一个数组,如何找出数组中所有和为 0 的 3 个数字的三元组?
# 需要注意的是,返回值中不得包含重复的三元组
# 例如,在数组[-1, 0, 1, 2, -1, -4]中有两个三元组的和为 0,它们分别是[-1, 0, 1]和[-1, -1, 2]
function ()
    
end


@testitem "Array_two_pointer" begin
    using Algorithms: find_indices
    @test find_indices([1, 2, 4, 6, 10], 8) == (2, 4)
end

Mytest(:BenchmarkTools) do
    @eval begin
        @btime find_indices([1, 2, 4, 6, 10], 8)
        @btime find_indices_fixed([1, 2, 4, 6, 10], 8)
        @info "Same Performance"
    end
end

