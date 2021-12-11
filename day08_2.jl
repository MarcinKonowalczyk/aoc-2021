using DelimitedFiles

# data_file = "./data/test/day08_input.txt"
data_file = "./data/full/day08_input.txt"
data = readdlm(data_file, ' ', String)

inputs = data[:, 1:10]
outputs = data[:, 12:end]

const Wiring = Set{Char}

# overload minus with some helpful set operations
import Base.-
@inline -(s1::Wiring, s2::Wiring) = setdiff(s1, s2)
@inline -(s1::Wiring, s2::Char) = setdiff(s1, Wiring(s2))
@inline -(s1::Vector{Wiring}, s2::Wiring) = [e - s2 for e in s1]
@inline -(s1::Vector{Wiring}, s2::Char) = [e - Wiring(s2) for e in s1]

# do this instead of boradcasting
# bordcast like Vector{Wiring} .- Wiring gets confused, since both left and right have length

wiring_map = Dict{String,Int}(
    "abcefg" => 0,
    "cf" => 1,
    "acdeg" => 2,
    "acdfg" => 3,
    "bcdf" => 4,
    "abdfg" => 5,
    "abdefg" => 6,
    "acf" => 7,
    "abcdefg" => 8,
    "abcdfg" => 9,
)

import Base.map, Base.reduce, Base.filter
map(f) = Base.Fix1(map, f)
map(d::Dict) = Base.Fix1(map, x -> d[x])
reduce(f) = Base.Fix1(reduce, f)
filter(f) = Base.Fix1(filter, f)

# Sort string
stringsort = join ∘ sort ∘ collect

# digit base 10 array to number
digitise =
    (x -> x[2]) ∘ reduce((x, y) -> (0, x[2] + 10^(y[1] - 1) * y[2])) ∘ enumerate ∘ reverse

# Helper functions for searching through the input vector
filtern(n) = filter(x -> x[1] == n) ∘ map(x -> (length(x), x))
single = Set ∘ x -> x[1][2]
filterone = single ∘ filtern(1)
many = map(Set ∘ x -> x[2])
item(x::Wiring) = collect(x)[1] # get first item from a set

N = size(inputs, 1)
translated_outputs = zeros(Int, N)
for (row_index, (input, output)) in enumerate(zip(eachrow(inputs), eachrow(outputs)))

    # Find 
    two = input |> filtern(2) |> single
    three = input |> filtern(3) |> single
    four = input |> filtern(4) |> single
    five = input |> filtern(5) |> many

    a = three - two |> item
    diff = five - four - a
    g = diff |> filterone |> item
    e = (diff - g) |> filterone |> item
    d = (five - three - g) |> filterone |> item
    b = (five - e - g - d - three) |> filterone |> item
    c = (five - e - g - d - a) |> filterone |> item
    f = two - c |> item

    decode_map = Dict{Char,Char}(
        a => 'a',
        b => 'b',
        c => 'c',
        d => 'd',
        e => 'e',
        f => 'f',
        g => 'g',
    )

    translated_outputs[row_index] =
        output |> map(stringsort ∘ map(decode_map)) |> map(wiring_map) |> digitise
end

sum_of_outputs = sum(translated_outputs)

@show sum_of_outputs

answer = sum_of_outputs
