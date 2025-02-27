"利用宏实现代码的复制粘贴"
macro def_base(name, definition)
    return quote
        macro $(esc(name))()
            esc($(Expr(:quote, definition)))
        end
    end
end

@def_base whatup begin 
    # var"local"::Int# you can make var"local" into a variable,
    # or the var"x" to be the variable, but the extension will crash
    x::Int64
    y::Float64
    z::AbstractString
end

struct test_struct
    @whatup
    h::Int
end

test_struct|>dump

test_struct(1,2.0-1im,"dsf",8)
dump(test_struct)

:(struct test_2
    # var"local"::Int# you can make var"local" into a variable,
    # or the var"x" to be the variable, but the extension will crash
    x::Int64
    y::Float64
    z::AbstractString
end) |>dump

Meta.parse("""whatup(3,4,"5")""")|>dump

######################################################

struct test_2
    # var"local"::Int# you can make var"local" into a variable,
    # or the var"x" to be the variable, but the extension will crash
    x::Int64
    y::Float64
    z::AbstractString
end


struct test_3
    x::Int
    y::Float32
end

"copy the field name of a given struct"
macro inherit(st)
    data_type = Core.eval(@__MODULE__,st)
    ex = Expr(:block)
    for (n,t) in zip(fieldnames(data_type),fieldtypes(data_type))
        push!(ex.args,Expr(:(::),Symbol(n),t))
    end
    @show ex
    # return nothing
    s_name = Symbol("$(st)_inherit")
    return quote
        macro $(esc(s_name))()
            esc($(Expr(:quote, ex)))
        end
    end
end

@inherit test_3


struct test_4
    @test_3_inherit
end

dump(test_4)

dump(test_4)

te.args

ex = quote
    x::Int64
    y::Float32
end

ex = quote
    struct test_3
        x::Int
    end
end|>dump

ex|>dump

Expr(:quote)
############################################################################################


abstract type AbstractPerson end
# basic methods to define: name,age,set_age

#basic AbstractPerson
mutable struct Person <: AbstractPerson
    name::String
    age::Int 
end

person(a::Person) = a

# CONSTRUCTOR
Person(name) = Person(name, 0)

#basic methods
name(a::AbstractPerson) = person(a).name
age(a::AbstractPerson)  = person(a).age
set_age(a::AbstractPerson,x::Integer) = (person(a).age = x; x)

# TYPE METHODS: always use `AbstractPerson` as input type...
Base.display(p::AbstractPerson) = println("Person: ", name(p), " (age: ", age(p), ")")

function happybirthday(p::AbstractPerson)
    set_age(p, age(p) + 1)
    println(name(p), " is now ", age(p), " year(s) old")
end

call(p::AbstractPerson) = (print_with_color(:red, uppercase(name(p)), "!"); println())

#---------------------------------------------------------------------
# DERIVED TYPE : Citizen

# Use abstract type for the interface name, by convention prepend
# `Abstract` to the type name.
abstract type AbstractCitizen <: AbstractPerson end

# here you should think of basic methods for a AbstractCitizen,
# such as nationality(c::AbstractCitizen).

# TYPE MEMBERS (composition of `Person` fields and new ones)
mutable struct Citizen <: AbstractCitizen
    person::Person
    nationality::String # new field (not present in Person)
end

person(c::Citizen) = c.person

#basic abstractcitizen method
nationality(c::Citizen) = c.nationality

#Now everything defined for AbstractPerson should work for Citizen

#And you are not tied to field names anymore:

struct EternalBeing <: AbstractPerson end

name(e::EternalBeing) = "The One who Is"
age(e::EternalBeing) = typemax(Int)
set_age(e::EternalBeing, x::Integer) = nothing

const eternal = EternalBeing()

# All just work
display(eternal)
happybirthday(eternal)
call(eternal)

println()

zulima = Citizen(Person("Zulima Martín García", 44), "Spain")
display(zulima)
happybirthday(zulima)
call(zulima)