for i in 1:3
    @eval function $(Symbol("f$i"))()
        println("This is function $($i)")
    end
end

f1()  # This is function 1
f2()  # This is function 2
f3()  # This is function 3


for i in 1:3
    eval(quote
        function $(Symbol("g$i"))()
            println("This is function $($i)")
        end
    end)
end

g1()  # This is function 1
g2()  # This is function 2
g3()  # This is function 3

:(:(a=1))
Expr(:quote, :(a=1))

:(:(a=1)) == Expr(:quote, :(a=1))

macro defName(name, definition)
    return quote
        macro $(esc(name))()
            esc($(Expr(:quote, definition)))
        end
    end
end
