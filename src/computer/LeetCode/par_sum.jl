### 前缀和
b = cumsum(1:10)
c = foldr((x,y)->"$x+($y)",1:10)
d = foldl((x,y)->"($x)+$y",1:10)

reduce(-,[1,2,3])
cumprod([1:10;])
cumsum([1:10;])


f = (x,y) -> "$x+($y)"

accumulate(f,string.(['1':'9';]))

mapreduce
mapfoldl
mapfoldr
mapslices
