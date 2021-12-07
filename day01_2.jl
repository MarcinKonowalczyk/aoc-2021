using DelimitedFiles

data_file = "./data/reduced/day01_input.txt"
# data_file = "./data/full/day01_input.txt"
data = readdlm(data_file, '\n', Int)[:]

triples = [data[i:i+2] for i = 1:length(data)-2]
averages = [sum(t) for t in triples]
increases = sum(diff(averages) .> 0)

@show increases
answer = increases
