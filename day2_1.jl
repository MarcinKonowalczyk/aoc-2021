using DelimitedFiles

data_file = "./data/day2_input.txt"
# data_file = "./data_full/day2_input.txt"
data = readdlm(data_file, ' ')
C = [Char(d[1]) for d in data[:,1]]
X = Vector{Int}(data[:,2])

position, depth = 0, 0

for (com, x) in zip(C, X)
    global position, depth
    if com == 'f'
        position += x
    elseif com == 'u'
        depth -= x
    elseif com == 'd'
        depth += x
    end
end

print("position = ", position, " | depth = ", depth, '\n')
print("position x depth = ", position * depth, '\n')