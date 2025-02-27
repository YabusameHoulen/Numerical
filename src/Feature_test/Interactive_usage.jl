filter(x->!isconst(Main,x),names(Main))

function unbindvariables()
    for name in names(Main)
        if !isconst(Main, name)
            Main.eval(:($name = nothing))
        end
    end
end

unbindvariables()
GC.gc()