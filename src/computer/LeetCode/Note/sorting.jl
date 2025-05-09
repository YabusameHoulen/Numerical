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
    if length(arr) <= 1
        return arr
    else
        mid_idx = div(length(arr), 2)
        left_arr = merge_sort(arr[1:mid_idx])
        right_arr = merge_sort(arr[(mid_idx+1):end])
        merged_arr = []
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



# using JET
## benchmark
Mytest(:BenchmarkTools) do
    eval(quote
        @btime selection_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime bubble_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime insertion_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime merge_sort([3, 1, 4, 1, 5, 9, 2, 6])
        @btime quick_sort([3, 1, 4, 1, 5, 9, 2, 6])
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
    @test Algorithms.quick_sort([3, 1, 4, 1, 5, 9, 2, 6]) == [1, 1, 2, 3, 4, 5, 6, 9]
end