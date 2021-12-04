using DelimitedFiles

data_file = "./data/day02_input.txt"
# data_file = "./data_full/day02_input.txt"
data = readdlm(data_file, ' ')
C = [Char(d[1]) for d in data[:,1]]
X = Vector{Int}(data[:,2])

position, depth = 0, 0
aim = 0

for (com, x) in zip(C, X)
    global position, depth, aim
    if com == 'f'
        position += x
        depth += x * aim
    elseif com == 'd'
        aim += x
    elseif com == 'u'
        aim -= x
    end
end

position_x_depth = position * depth
@show position, depth
@show position_x_depth
answer = position_x_depth