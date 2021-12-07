using DelimitedFiles

data_file = "./data/reduced/day07_input.txt"
# data_file = "./data/full/day07_input.txt"
data = readdlm(data_file, '\n', Int16)

crabs = data[:]

crab_buckets = zeros(Int64, maximum(crabs)+1)
for crab in crabs
    crab_buckets[crab+1] += 1
end

move_cost = zeros(Int64, size(crab_buckets))
steps = abs.(Vector(0:(length(crab_buckets) - 1)))
for bucket_index in eachindex(crab_buckets)
    let steps = abs.(steps .- (bucket_index-1))
        distances = [(n*(n+1)) >> 1 for n in steps]
        move_cost[bucket_index] = sum(crab_buckets .* distances)
    end
end

min_index = argmin(move_cost)
min_move_cost = move_cost[min_index]

@show min_index - 1
@show min_move_cost

answer = min_move_cost
