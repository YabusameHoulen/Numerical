arr1 = zeros(1000000)

function put1!(arr)
    for i in 1:length(arr)
        arr[i] = 1.0
    end
end

function put1_inbounds!(arr)
    @inbounds for i in 1:length(arr)
        arr[i] = 1.0
    end
end

function put2_inbounds!(arr)
    for i in eachindex(arr)
        arr[i] = 1.0
    end
end

@btime put1!($arr1)

@btime put1_inbounds!($arr1)

@btime put2_inbounds!($arr1)


## this is a block
const N = 2001;
const Fo = 1e-2;
const h = 1 / (N - 1);
const T = zeros(N, N);
const Th = 0.5;
const Tc = -0.5;
const Time = 10000;
const dt = 0.1;

@views function energy(Time, N, T, Th, Fo, dt, Tc, h, Tn) # Additional parameter Tn
    for iter = 1:Time
        Tn .= T
        @. T[2:N-1, 2:N-1] = Tn[2:N-1, 2:N-1] + Fo * dt * ((Tn[3:N, 2:N-1] - 2 * Tn[2:N-1, 2:N-1] + Tn[1:N-2, 2:N-1]) / h + (Tn[2:N-1, 3:N] - 2 * Tn[2:N-1, 2:N-1] + Tn[2:N-1, 1:N-2]) / h)
        T[1:N, 1] .= Th
        T[1:N, N] .= Tc
        T[1, 1:N] .= T[2, 1:N]
        T[N, 1:N] .= T[N-1, 1:N]
    end
end

Tn = similar(T);
@btime energy($Time, $N, $T, $Th, $Fo, $dt, $Tc, $h, $Tn)
