function my_div(divident::Integer, divisor::Integer)
    if divident == -typemax(typeof(divident)) && divisor == -1
        return typemax(typeof(divident))
    end
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
    
end


@testitem "Integer" begin
    @test 3 == 1
end