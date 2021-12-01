using DelimitedFiles

data_file = "./data/day1_input.txt"
# data_file = "./data_full/day1_input.txt"
data = readdlm(data_file, '\n', Int)[:]

triples = [data[i:i+2] for i in 1:length(data)-2]
averages = [sum(t) for t in triples]
increases = sum(diff(averages).>0)
print(increases)