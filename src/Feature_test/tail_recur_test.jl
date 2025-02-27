function tail_recur(num,res)
    num == 0 && return res
    return tail_recur(num-1,res+num)
end

tail_recur(86793,0)

# julia can't do tail_recursion

@time fill(50,40000);
@time [50 for _ in 1:40000];

test = fill(42)

test[] = 43

const testing = Ref(43)
test == testing

test = [1:5;]
insert!(test,3,40)
deleteat!(test,3)
findfirst(==(5),test)
push!(test,5,5,5)
findall(==(5),test)