using DelimitedFiles

data_file = "./data/reduced/day06_input.txt"
# data_file = "./data/full/day06_input.txt"
data = readdlm(data_file, '\n', Int8)

fish_buckets = zeros(UInt64, 9)

for fish in data
    fish_buckets[fish+1] += 1
end

for day = 1:256
    temp_fish_buckets = zeros(UInt64, 9)
    for (bucket_number, bucket) in enumerate(fish_buckets)
        if bucket_number == 1
            temp_fish_buckets[6+1] += bucket
            temp_fish_buckets[8+1] += bucket
        else
            temp_fish_buckets[bucket_number-1] += bucket
        end
    end
    global fish_buckets = copy(temp_fish_buckets)
    @show day, Int.(fish_buckets)
end

number_of_fish = Int(sum(fish_buckets))
@show number_of_fish
answer = number_of_fish
