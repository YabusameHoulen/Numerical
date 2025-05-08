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


@testitem "Integer" begin
    using Algorithms: my_div
    @test my_div(-15, 2) == -7
end