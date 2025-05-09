module MyPackage

using TestItems

export foo

foo(x) = x

# @testitem "First tests" begin
#     using Algorithms.MyPackage
#     x = foo("bar")

#     @test length(x) == 3
#     @test x == "bar"
# end

end