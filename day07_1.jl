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
steps = Vector(0:(length(crab_buckets) - 1))
for (bucket_index, bucket) in enumerate(crab_buckets)
    let distances = abs.(steps .- (bucket_index-1))
        move_cost[bucket_index] = sum(crab_buckets .* distances)
    end
end

# @show move_cost
min_index = argmin(move_cost)
min_move_cost = move_cost[min_index]

@show min_index - 1
@show min_move_cost

answer = min_move_cost
