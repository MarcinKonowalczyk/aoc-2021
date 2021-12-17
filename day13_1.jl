using DelimitedFiles

# data_file = "./data/test/day13_input.txt"
data_file = "./data/full/day13_input.txt"
data = readdlm(data_file, ',', String; skipblanks = false)

# Parse input file
points = Vector{Tuple{Int64,Int64}}([])
folds = Vector{Tuple{Char,Int64}}([])
parsing_points = true
for entry in eachrow(data)
    if entry[1] == ""
        global parsing_points = false
        continue
    end

    if parsing_points
        push!(points, Tuple(map(x -> parse(Int, x) + 1, entry)))
    else
        ins = split(split(entry[1], ' ')[3], '=')
        push!(folds, (ins[1][1], parse(Int, ins[2]) + 1))
    end
end

M, N = reduce((x, y) -> (max(x[1], y[1]), max(x[2], y[2])), points)

paper = falses((N, M))

for (x, y) in points
    paper[y, x] = true
end

fold, crease = folds[1]
# fold, crease = folds[2]

if fold == 'x'
    @assert sum(paper[:, crease]) == 0 "Crease not at all-zeros!"
    left = paper[:, 1:(crease-1)]
    right = paper[:, end:-1:(crease+1)]
    if size(left, 1) < size(right, 1)
        right = right[:, end-size(left, 1)+1:end]
    elseif size(left, 1) > size(right, 1)
        left = left[:, end-size(right, 1)+1:end]
    end
    @assert size(left) == size(right) "left and right bit matrices should have equal sizes now"
    paper = left .| right
else # fold == 'y'
    @assert sum(paper[crease, :]) == 0 "Crease not at all-zeros!"
    top = paper[1:(crease-1), :]
    bottom = paper[end:-1:(crease+1), :]
    if size(top, 2) < size(bottom, 2)
        bottom = bottom[end-size(top, 2)+1:end, :]
    elseif size(top, 2) > size(bottom, 2)
        top = top[end-size(bottom, 2)+1:end, :]
    end
    @assert size(top) == size(bottom) "top and bottom bit matrices should have equal sizes now"
    paper = top .| bottom
end

if size(paper, 2) < 20
    for line in eachrow(paper)
        for bit in line
            color = bit ? :blue : :light_black
            symbol = bit ? '#' : '.'
            printstyled(symbol; color = color, bold = bit)
            print(" ")
        end
        print("\n")
    end
else
    println("paper too big to display")
end

dots_after_first_fold = sum(paper)

@show dots_after_first_fold

answer = dots_after_first_fold
