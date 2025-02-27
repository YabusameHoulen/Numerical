@kwdef mutable struct ListNode{T}
    next::Union{ListNode,Nothing} = nothing
    val::T
end
ListNode(next, val::T) where {T} = ListNode{T}(next, val)
ListNode(val::T) where {T} = ListNode{T}(nothing, val)

n0 = ListNode(1)
n1 = ListNode(3)
n2 = ListNode(2)
n3 = ListNode(5)
n4 = ListNode(4)
# 构建节点之间的引用
n0.next = n1
n1.next = n2
n2.next = n3
n3.next = n4
n4.next = n0

function Base.insert!(n0::ListNode,P::ListNode)
    n1 = n0.next
    P.next = n1
    n0.next = P
    return nothing
end

function Base.deleteat!(n0::ListNode)
    n1 = n0.next
    n0.next = n1.next
end
insert!(n4,ListNode(999))
deleteat!(n3)
