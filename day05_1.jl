using DelimitedFiles

data_file = "./data/test/day05_input.txt"
# data_file = "./data/full/day05_input.txt"
data = readdlm(data_file, String)

left, right = zeros(Int64, (size(data,1),2)), zeros(Int64, (size(data,1),2))
for (data_left, data_right, row_left, row_right) in zip(data[:,1], data[:,3], eachrow(left), eachrow(right))
    row_left[1:2] = [parse(Int64,n)+1 for n in split(data_left,",")]
    row_right[1:2] = [parse(Int64,n)+1 for n in split(data_right,",")]
end

x_max = maximum([left[:,1]; right[:,1]])
y_max = maximum([left[:,2]; right[:,2]])

@show x_max, y_max

grid = zeros(Int64, (x_max, y_max))
for (p1, p2) in zip(eachrow(left), eachrow(right))
    @show p1, p2
    if (p1[1] == p2[1]) | (p1[2] == p2[2])
        x_range = min(p1[1],p2[1]):max(p1[1],p2[1])
        y_range = min(p1[2],p2[2]):max(p1[2],p2[2])
        grid[x_range, y_range] .+= 1
    end
end
# grid = Matrix{Int64}(grid')

tall_points = sum(grid .> 1)
@show tall_points

answer = tall_points