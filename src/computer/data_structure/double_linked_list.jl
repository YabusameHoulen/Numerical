@kwdef mutable struct ListNode{T}
    val::T=0
    prev::Union{ListNode,Nothing} = nothing
    next::Union{ListNode,Nothing} = nothing
end

n1 = ListNode()
n2 = ListNode()

n1.next = n2
n2.prev = n1

n1.prev = n2
n2.next = n1


n1.next.prev == n1

using Test

@testset begin
    @time @test n1.next === n2
    @time @test n1.prev === n2
    @test n2.prev === n2.next ===n1
end
