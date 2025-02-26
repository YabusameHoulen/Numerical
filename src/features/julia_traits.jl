abstract type Animal end
for name in [:Bird, :Fish, :Horse, :Fox]
    @eval struct $name <: Animal
        alive::Bool
    end
end
abstract type Human end
struct Person <: Human
    alive::Bool
end

## Original Holy Trait

# define a trait
abstract type Fly end
struct CanFly <: Fly end
struct NotFly <: Fly end

# trait function -> define on the type
testflyable(::Type{<:Animal}) = NotFly()
testflyable(::Type{Bird}) = CanFly()
testflyable(::Type{Person}) = CanFly()
# dispatch on trait -> implement on trait behaviour
after_crossriver(x::T) where {T} = after_crossriver(testflyable(T), x)
after_crossriver(::CanFly, x) = x.alive
function after_crossriver(::NotFly, x)
    if x.alive
        return false
    end
    x.alive
end
after_crossriver(x::Fish) = x.alive

## Simple Trait
using SimpleTraits

@traitdef CanFly{T}
@traitimpl CanFly{Bird}
@traitimpl CanFly{Person}
@traitfn after_crossriver(x::::CanFly) = x.alive
methods(after_crossriver)
@traitfn function after_crossriver(x::::(!CanFly))
    if x.alive
        return false
    end
    x.alive
end
after_crossriver(x::Fish) = x.alive

istrait(CanFly{Bird})
@check_fast_traitdispatch CanFly
@check_fast_traitdispatch CanFly Person
## Canonical Trait
using CanonicalTraits
@trait CanFly{T} begin
    after_crossriver::T => Bool
end

@implement CanFly{T} where {T} begin
    function after_crossriver(x)
        if x.alive
            return false
        end
        x.alive
    end
end

@implement CanFly{T} where {T<:Animal} begin
    after_crossriver(x) = x.alive
end

@implement CanFly{Person} begin
    after_crossriver(x) = x.alive
end

methods(after_crossriver)

## Test
fish = Fish(true)
cold_fish = Fish(false)
bird = Bird(true)
dead_bird = Bird(false)
human = Person(true)

# testflyable(Fish)
# testflyable(Bird)
# testflyable(Person)

after_crossriver(bird)
after_crossriver(dead_bird)
after_crossriver(fish)
after_crossriver(cold_fish)
after_crossriver(human)

