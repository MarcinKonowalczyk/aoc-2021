using DelimitedFiles

data_file = "./data/day2_input.txt"
# data_file = "./data_full/day2_input.txt"
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

print("position = ", position, " | depth = ", depth, " | aim = ", aim, '\n')
print("position x depth = ", position * depth, '\n')