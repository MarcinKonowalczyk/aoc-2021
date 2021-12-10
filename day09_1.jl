using DelimitedFiles

# data_file = "./data/test/day09_input.txt"
data_file = "./data/full/day09_input.txt"
data = readdlm(data_file, ' ', String)

N, M = (size(data, 1), length(data[1]))

heightmap = zeros(Int, (N, M))
for (ri, row) in enumerate(data)
    for (di, digit) in enumerate(row)
        heightmap[ri, di] = parse(Int, digit)
    end
end

# Pad the heightmap with 9's
padded_heightmap = fill(9, (N + 2, M + 2))
padded_heightmap[2:end-1, 2:end-1] = heightmap

# Calculate horizontal and vertical 1st differences
horizontal_conv = padded_heightmap[2:end-1, 2:end] - padded_heightmap[2:end-1, 1:end-1]
left_diff = horizontal_conv[:, 1:end-1]
right_diff = -horizontal_conv[:, 2:end]
vertical_conv = padded_heightmap[2:end, 2:end-1] - padded_heightmap[1:end-1, 2:end-1]
down_diff = vertical_conv[1:end-1, :]
up_diff = -vertical_conv[2:end, :]

# find low low_points as a list of CartesianIndices
low_points = (left_diff .< 0) .& (right_diff .< 0) .& (down_diff .< 0) .& (up_diff .< 0)

sum_low_points = sum(heightmap[low_points] .+ 1)

@show sum_low_points

answer = sum_low_points
