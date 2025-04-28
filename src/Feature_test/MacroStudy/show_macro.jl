macro showing(x)
    return :(
        println($"$x = ", $(esc(x)))
    )
end


macro showing(x)
    return quote
        println($"$x = ", $(esc(x)))
    end
end

macro showing(x)
    return quote
        println($"$x = ", $(esc(x)))
    end
end

xxx = 3
@showing xxx

Expr(:quote, 3)
Expr(:quote, 3)|>dump

quote
    3
end|>dump

:(:(
3
))|>dump