using DelimitedFiles

data_file = "./data/test/day05_input.txt"
# data_file = "./data/full/day05_input.txt"
data = readdlm(data_file, String)

left, right = zeros(Int64, (size(data, 1), 2)), zeros(Int64, (size(data, 1), 2))
for (data_left, data_right, row_left, row_right) in
    zip(data[:, 1], data[:, 3], eachrow(left), eachrow(right))
    row_left[1:2] = [parse(Int64, n) + 1 for n in split(data_left, ",")]
    row_right[1:2] = [parse(Int64, n) + 1 for n in split(data_right, ",")]
end

x_max = maximum([left[:, 1]; right[:, 1]])
y_max = maximum([left[:, 2]; right[:, 2]])

@show x_max, y_max

grid = zeros(UInt8, (x_max, y_max))
for (x1, y1, x2, y2) in zip(left[:, 1], left[:, 2], right[:, 1], right[:, 2])
    # make sure x goes left to right
    if x1 > x2
        x1, x2 = x2, x1
        y1, y2 = y2, y1
    end
    if (x1 == x2) | (y1 == y2)
        grid[x1:x2, min(y1, y2):max(y1, y2)] .+= 1
    else
        # @assert x2-x1 == abs(y2-y1) "not a 45d line!"
        ys = sign(y2 - y1) # y gies up or down?
        for j = 0:(x2-x1)
            grid[x1+j, y1+ys*j] += 1
        end
    end
end

tall_points = sum(grid .> 1)
@show tall_points

answer = tall_points
