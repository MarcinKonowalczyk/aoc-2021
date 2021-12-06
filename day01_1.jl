using DelimitedFiles

data_file = "./data/reduced/day01_input.txt"
# data_file = "./data/full/day01_input.txt"
data = readdlm(data_file, '\n', Int)[:]

increases = sum(diff(data).>0)
@show increases
answer = increases