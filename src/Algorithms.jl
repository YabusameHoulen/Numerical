module Algorithms

using TestItems

### helper functions
Mytest(f, cond::Symbol) = isdefined(@__MODULE__, cond) && f()

includeF(src_path::String) = include.(
    filter!(
        endswith(".jl"),
        readdir("$(@__DIR__)/$(src_path)", join=true)
    )
)

### leet code
includeF("computer/LeetCode/Weird")
includeF("computer/LeetCode/Note")


### features
# include("Feature_test/value_can_partially_change.jl")
# include("Feature_test/test_module.jl")
# using .MyPackage

### numerical
# include("numerical/parallel_matrix.jl")
end