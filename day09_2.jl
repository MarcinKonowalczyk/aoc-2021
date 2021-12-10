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
low_points = findall(low_points)

# flood-fill each low point
floodmap = zeros(Bool, (N, M))
basin_sizes = zeros(Int, length(low_points))

up, down, left, right =
    CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1)

for (basin_index, low_point) in enumerate(low_points)
    floodfill_points = [low_point]
    while length(floodfill_points) > 0
        point = pop!(floodfill_points)
        floodmap[point] && continue
        floodmap[point] = true
        basin_sizes[basin_index] += 1

        point[1] > 1 && heightmap[point+up] != 9 && push!(floodfill_points, point + up)
        point[1] < N && heightmap[point+down] != 9 && push!(floodfill_points, point + down)
        point[2] > 1 && heightmap[point+left] != 9 && push!(floodfill_points, point + left)
        point[2] < M &&
            heightmap[point+right] != 9 &&
            push!(floodfill_points, point + right)
    end
end

largest_basins = sort(basin_sizes, rev = true)[1:3]
prod_largest_basins = prod(largest_basins)

@show largest_basins
@show prod_largest_basins

answer = prod_largest_basins
