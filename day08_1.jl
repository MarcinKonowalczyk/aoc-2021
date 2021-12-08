using DelimitedFiles

# data_file = "./data/test/day08_input.txt"
data_file = "./data/full/day08_input.txt"
data = readdlm(data_file, ' ', String)

input = data[:, 1:10]
output = data[:, 12:end]

digit_segments = [6, 2, 5, 5, 4, 5, 6, 3, 7, 6]
segment_frequencies = [sum(digit_segments .== d) for d in digit_segments]
unit_indices = findall(segment_frequencies .== 1)
unique_digits = unit_indices .- 1
unique_digit_segments = sort(digit_segments[unit_indices])

unique_digits_in_output = sum(map(x->x in unique_digit_segments, length.(output)))
@show unique_digits_in_output
answer = unique_digits_in_output