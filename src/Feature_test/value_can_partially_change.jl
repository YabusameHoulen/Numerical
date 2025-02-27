mutable struct MovingPoint
    x::Float64
    y::Float64
end


abstract type Pear end
struct MovingPoint2 <: Pear
    x::Base.RefValue{Float64}
    y::Base.RefValue{Float64}
end

function move!(x::MovingPoint)
    x.x += rand()
    x.y += rand()
end

function move!(x::MovingPoint2)
    x.x[] += rand()
    x.y[] += rand()
end

function test1(p::MovingPoint)
    for i in 1:10^8
        move!(p)
    end
end
p = MovingPoint(0, 0)


function test2(p::MovingPoint2)
    for i in 1:10^8
        move!(p)
    end
end
p = MovingPoint2(Base.RefValue(0.0), Base.RefValue(0.0))
