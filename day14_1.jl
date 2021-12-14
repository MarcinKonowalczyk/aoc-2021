using DelimitedFiles

# data_file = "./data/test/day14_input.txt"
data_file = "./data/full/day14_input.txt"
data = readdlm(data_file, ' ', String)

sequence = data[1,1]
insertion_rules = data[2:end,[1,3]]

N_template = lpad(length(sequence), 6, "0")
println("Template       ($N_template) : $sequence")

for epoch in 1:10
    # find all the insertions to be made
    insertions = Vector{Tuple{Vector{Int}, Char}}([])
    for rule in eachrow(insertion_rules)
        matches = findall(rule[1], sequence; overlap=true)
        if !isempty(matches)
            push!(insertions, ([m[1] for m in matches], rule[2][1]))
        end
    end

    # Count all the insertions
    local N = reduce(insertions; init = (0,' ')) do x, y
        return (x[1] + length(y[1]), ' ')
    end[1] + length(sequence)

    new_sequence = fill('-', N)
    sequence_offset = 0
    for (si, element) in enumerate(sequence)
        new_sequence[si + sequence_offset] = element
        for (iis, new_element) in insertions
            if si in iis
                sequence_offset += 1
                new_sequence[si + sequence_offset] = new_element
            end
        end
    end

    global sequence = join(new_sequence)
    epoch_string, N_string = lpad(epoch, 3, "0"), lpad(N, 6, "0")
    if length(sequence) < 50
        println("After step $epoch_string ($N_string) : $sequence")
    else
        head, tail = sequence[1:20], sequence[end-19:end]
        println("After step $epoch_string ($N_string) : $head ... $tail")
    end
end

tally = Dict{Char, Int}()
for element in sequence
    element in keys(tally) || (tally[element] = 0)
    tally[element] += 1
end

@show tally

max_element = reduce((x,y)->(x.second > y.second) ? x : y, tally)
min_element = reduce((x,y)->(x.second < y.second) ? x : y, tally)

@show max_element
@show min_element

minmax_difference = max_element.second - min_element.second

@show minmax_difference

answer = minmax_difference
