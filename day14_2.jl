using DelimitedFiles

# data_file = "./data/test/day14_input.txt"
data_file = "./data/full/day14_input.txt"
data = readdlm(data_file, ' ', String)

sequence = data[1,1]
insertion_rules = data[2:end,[1,3]]
insertion_rules = Dict(x[1]=>x[2][1] for x in eachrow(insertion_rules))

import Base.+
+(s1::Set{Char}, s2::Set{Char}) = union(s1,s2)
+(s1::Set{Char}, s2::Char) = union(s1, Set{Char}(s2))
+(s1::Set{Char}, s2::String) = union(s1, Set{Char}(s2))

N_template = lpad(length(sequence), 6, "0")
println("Template       ($N_template) : $sequence")

# Find all unique elements in both the sequence and the insertion rules
unique_elements = reduce(insertion_rules; init = Set{Char}(sequence)=>nothing) do x, y
    return (x.first + y.first + y.second)=>nothing
end.first

@show unique_elements

pair_counter = Dict{String, Int}()
empty_counter = Dict{String, Int}()
for (x, y) in Base.Iterators.product(unique_elements, unique_elements)
    pair_counter[x*y] = length(findall(x*y, sequence; overlap=true))
    empty_counter[x*y] = 0
end
@assert sum(values(pair_counter)) == length(sequence)-1 "Invalud number of counted pairs"


for epoch in 1:40
    new_counter = copy(empty_counter)
    for (pair, count) in pair_counter
        if count > 0
            if pair in keys(insertion_rules)
                inserted_element = insertion_rules[pair]
                left_pair = pair[1] * inserted_element
                right_pair = inserted_element * pair[2]
                new_counter[left_pair] += count
                new_counter[right_pair] += count
            else
                new_counter[pair] += count
            end
        end
    end
    global pair_counter = new_counter

    epoch_string = lpad(epoch, 3, "0")
    N_string = lpad(sum(values(pair_counter)), 6, "0")
    print("After step $epoch_string ($N_string) : ")
    if epoch < 10
        printed_so_far = 0
        for (key, value) in pair_counter
            if value > 0 && printed_so_far < 15
                value_string = rpad(value,3," ")
                print("$key-$value_string ")
                printed_so_far += 1
            end
        end
    end
    print(" ... \n")
end

tally = Dict{Char, Int}()
for (pair, count) in pair_counter
    element = pair[1] # tally by forst element of each pair to avoid double counting
    element in keys(tally) || (tally[element] = 0)
    tally[element] += count
end
# Add the count of the terminal element of the sequence
# Note that the terminal element never changes (nor the initial)
tally[sequence[end]] += 1

@show tally

max_element = reduce((x,y)->(x.second > y.second) ? x : y, tally)
min_element = reduce((x,y)->(x.second < y.second) ? x : y, tally)

@show max_element
@show min_element

minmax_difference = max_element.second - min_element.second

@show minmax_difference

# answer = minmax_difference
