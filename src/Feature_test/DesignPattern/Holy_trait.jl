abstract type Animal end

abstract type Bird <: Animal end

struct Chiken <: Bird
    sound::AbstractString
end

struct Swallor <: Bird
    sound::AbstractString
end


### 特征需要额外创建单例作为 trait 派发
struct Flyable end
struct NotFlyable end
Is_flyable(::Bird) = Flyable()
Is_flyable(::Chiken) = NotFlyable()


### 使用函数根据 trait 进行派发
"""
    fly(x::Bird)

bird flying
"""
fly(x::Bird) = fly(Is_flyable(x), x)
fly(::Flyable, x::Bird) = println("I can fly ", x.sound)
fly(::NotFlyable, x::Bird) = println("I can't fly ", x.sound)


a = Swallor("AAA!!")
b = Chiken("Chirp")

fly(a)

fly(b)