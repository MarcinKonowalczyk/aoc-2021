using DelimitedFiles

data_file = "./data/reduced/day08_input.txt"
# data_file = "./data/full/day08_input.txt"
data = readdlm(data_file, ' ', String)

inputs = data[:, 1:10]
outputs = data[:, 12:end]

# copied and slightly adjusted, from https://github.com/JuliaMath/Combinatorics.jl
function kthperm(n::Integer, k::Integer)
    a = collect(1:n)
    n == 0 && return a
    f = factorial(oftype(k, n))
    0 < k <= f || throw(ArgumentError("permutation k must satisfy 0 < k ≤ $f, got $k"))
    k -= 1 # make k 1-indexed
    for i = 1:n-1
        f ÷= n - i + 1
        j = k ÷ f
        k -= j * f
        j += i
        elt = a[j]
        for d = j:-1:i+1
            a[d] = a[d-1]
        end
        a[i] = elt
    end
    return a
end

target = ["abcefg", "cf", "acdeg", "acdfg", "bcdf", "abdfg", "abdefg", "acf", "abcdefg", "abcdfg"]
sorted_target = sort(target)
wire_labels = collect("abcdefg")

translate(perm, digit) = join(sort([wire_labels[findfirst(wire_labels[perm] .== d)] for d in digit]))

N = size(inputs,1)
translated_outputs = zeros(Int, N)
for (row_index, (input, output)) in enumerate(zip(eachrow(inputs), eachrow(outputs)))
    perm = undef
    for k in 1:factorial(7)
        perm = kthperm(7, k)
        translated_input = sort([translate(perm, digit) for digit in input])
        translated_input == sorted_target && break
    end
    if perm === undef
        throw(ArgumentError("no permutation on row $row_index found"))
    else
        println("$row_index / $N | permutation found: $perm")
    end

    # @show perm
    # @show output[1]
    # @show findall(target .== translate(perm, output[1]))
    translated_output = sum(10 .^ (3:-1:0) .* [findfirst(target .== translate(perm, digit))-1 for digit in output])
    translated_outputs[row_index] = translated_output
end

sum_of_outputs = sum(translated_outputs)

@show translated_outputs
@show sum_of_outputs

answer = sum_of_outputs

