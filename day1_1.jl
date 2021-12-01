using DelimitedFiles

data_file = "./data/day1_input.txt"
# data_file = "./data_full/day1_input.txt"
data = readdlm(data_file, '\n', Int)[:]

increases = sum(diff(data).>0)
print(increases)