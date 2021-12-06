using DelimitedFiles

# data_file = "./data/test/day06_input.txt"
data_file = "./data/full/day06_input.txt"
data = readdlm(data_file, ',', Int8)

fish = copy(data)[:]

for _ in 1:80
    fish .-= 1
    local mask = fish .== -1
    fish[mask] .= 6
    append!(fish, fill(Int8(8), sum(mask)))
    # @show Int.(fish)
end

number_of_fish = length(fish)
@show number_of_fish
answer = number_of_fish
