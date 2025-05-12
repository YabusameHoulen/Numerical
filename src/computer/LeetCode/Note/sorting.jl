# Bubble Sort
function bubble_sort(arr)
    for i in 1:length(arr)-1
        for j in 1:(length(arr)-i)
            if arr[j] > arr[j+1]
                arr[j], arr[j+1] = arr[j+1], arr[j]
            end
        end
    end
    return arr
end


# Selection Sort
function selection_sort(arr)
    for i in 1:length(arr)-1
        min_idx = i
        for j in (i+1):length(arr)
            if arr[j] < arr[min_idx]
                min_idx = j
            end
        end
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
    end
    return arr
end


# Insertion Sort
function insertion_sort(arr)
    for i in Iterators.drop(eachindex(arr), 1)
        key = arr[i]
        j = i - 1
        while j > 0 && arr[j] > key
            arr[j+1] = arr[j]
            j -= 1
        end
        arr[j+1] = key
    end
    return arr
end

# Insertion Sort
function insertion_sort_2(arr)
    for i in 2:length(arr)
        key = arr[i]
        j = i - 1
        while j > 0 && arr[j] > key
            arr[j+1] = arr[j]
            j -= 1
        end
        arr[j+1] = key
    end
    return arr
end

# @time Iterators.drop(eachindex([3, 1, 4, 1, 5, 9, 2, 6]), 1)
# Iterators.take(eachindex([3, 1, 4, 1, 5, 9, 2, 6]), 1) |> collect
# Iterators.rest([3, 1, 4, 1, 5, 9, 2, 6], 5)


# Merge Sort
function merge_sort(arr)
    if length(arr) < 2
        return arr
    else
        mid_idx = length(arr) >> 1
        left_arr = merge_sort(arr[1:mid_idx])
        right_arr = merge_sort(arr[(mid_idx+1):end])
        merged_arr = Int[]
        while !isempty(left_arr) && !isempty(right_arr)
            if first(left_arr) <= first(right_arr)
                push!(merged_arr, popfirst!(left_arr))
            else
                push!(merged_arr, popfirst!(right_arr))
            end
        end
        return [merged_arr; left_arr; right_arr]
    end
end


function merge_sort_2(arr)
    if length(arr) < 2
        return arr
    else
        mid_idx = length(arr) >> 1
        left_arr = merge_sort_2(arr[1:mid_idx])
        right_arr = merge_sort_2(arr[(mid_idx+1):end]) ## 假设降序排列
        merged_arr = Int[]
        while !isempty(left_arr) && !isempty(right_arr)
            if last(left_arr) > last(right_arr) # 从两个降序排列的子数组里从小到大拿出元素
                push!(merged_arr, pop!(right_arr))
            else
                push!(merged_arr, pop!(left_arr))
            end
        end
        return [left_arr; right_arr; reverse!(merged_arr)]  # 保持降序排列
    end
end


function mergesort!(arr::AbstractVector)
    buffer = similar(arr)
    _mergesort!(arr, buffer, 1, length(arr))
    return arr
end

function _mergesort!(arr, buffer, left, right)
    if left >= right
        return
    end
    mid = (left + right) >> 1
    _mergesort!(arr, buffer, left, mid)
    _mergesort!(arr, buffer, mid + 1, right)
    merge!(arr, buffer, left, mid, right)
end

function merge!(arr, buffer, left, mid, right)
    ### k 为在buffer数组的位置
    i, j, k = left, mid + 1, left
    ### 主合并循环
    while i <= mid && j <= right
        if arr[i] <= arr[j]
            buffer[k] = arr[i]
            i += 1
        else
            buffer[k] = arr[j]
            j += 1
        end
        k += 1
    end
    ### 处理剩余元素
    while i <= mid
        buffer[k] = arr[i]
        i += 1
        k += 1
    end
    while j <= right
        buffer[k] = arr[j]
        j += 1
        k += 1
    end
    ### 结果复制回原数组
    for idx in left:right
        arr[idx] = buffer[idx]
    end
end


# Quick Sort
function quick_sort(arr)
    if length(arr) <= 1
        return arr
    else
        pivot = arr[end]
        left_arr = filter(x -> x < pivot, arr[1:end-1])
        right_arr = filter(x -> x >= pivot, arr[1:end-1])
        return [quick_sort(left_arr); pivot; quick_sort(right_arr)]
    end
end


### 确保索引比p大的元素值比p大，索引比p小的元素值比p小
### i + 1 作为索引p的位置
function partition!(arr, lo, hi)
    pivot = arr[hi]
    i = lo - 1
    for j in lo:hi-1
        if arr[j] <= pivot
            i += 1
            arr[i], arr[j] = arr[j], arr[i]  # 交换元素
        end
    end
    arr[i+1], arr[hi] = arr[hi], arr[i+1]
    return i + 1
end

### Quick inplace
function quicksort!(arr, lo=firstindex(arr), hi=lastindex(arr))
    if lo < hi
        p = partition!(arr, lo, hi)
        quicksort!(arr, lo, p - 1)
        quicksort!(arr, p + 1, hi)
    end
    return arr
end


### 和上面一样的逻辑，但是更容易理解？
function pivot!(arr::AbstractArray)
    p = firstindex(arr)
    for i in Iterators.drop(eachindex(arr), 1)
        if arr[i] < arr[p]
            arr[p+1], arr[i] = arr[i], arr[p+1]
            arr[p], arr[p+1] = arr[p+1], arr[p]
            p += 1
        end
    end
    return p
end

function quick_sort!(arr::AbstractArray)
    if length(arr) < 2
        return
    end
    p = pivot!(arr)
    quick_sort!(@view arr[begin:p])
    quick_sort!(@view arr[p+1:end])
end


## benchmark
Mytest(:BenchmarkTools) do
    eval(quote
        @btime selection_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime bubble_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime insertion_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime merge_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime merge_sort_2([3, 1, 4, 1, 5, 9, 2, 6])
        @btime mergesort!([3, 1, 4, 1, 5, 9, 2, 6])
        @btime quick_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime quicksort!([3, 1, 4, 1, 5, 9, 2, 6])
        @btime quick_sort!([3, 1, 4, 1, 5, 9, 2, 6])
        @info " @btime to test sort Algorithms' performance "
    end)
end

## Testing
@testitem "Sorting" begin
    @test Algorithms.selection_sort([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
    @test Algorithms.bubble_sort([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
    @test Algorithms.insertion_sort([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
    @test Algorithms.insertion_sort_2([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
    @test Algorithms.merge_sort([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
    @test Algorithms.merge_sort_2([3, 1, 4, 1, 5, 9, 2, 6]) == reverse!([1, 1, 2, 3, 4, 5, 6, 9])
    @test Algorithms.mergesort!([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
    @test Algorithms.quick_sort([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
    @test Algorithms.quicksort!([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
    a = [3, 1, 4, 1, 5, 9, 2, 6]
    Algorithms.quick_sort!(a)
    @test a == [1, 1, 2, 3, 4, 5, 6, 9]
end