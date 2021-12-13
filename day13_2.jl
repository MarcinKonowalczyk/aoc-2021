using DelimitedFiles

# data_file = "./data/test/day13_input.txt"
data_file = "./data/full/day13_input.txt"
data = readdlm(data_file, ',', String; skipblanks=false)

# Parse input file
points = Vector{Tuple{Int64, Int64}}([])
folds = Vector{Tuple{Char, Int64}}([])
parsing_points = true
for entry in eachrow(data)
    if entry[1] == ""
        global parsing_points = false
        continue
    end
    
    if parsing_points
        push!(points, Tuple(map(x->parse(Int,x)+1,entry)))
    else
        ins = split(split(entry[1],' ')[3],'=')
        push!(folds, (ins[1][1], parse(Int, ins[2])+1))
    end
end

M, N = reduce((x,y)->(max(x[1],y[1]),max(x[2],y[2])), points)

paper = falses((N,M))

for (x, y) in points
    paper[y, x] = true
end

begin
    for (fold, crease) in folds
        fold == 'y' || global paper = paper'
        @assert sum(paper[crease,:]) == 0 "Crease not at all-zeros!"
        local top, bottom = paper[1:(crease-1),:], paper[end:-1:(crease+1),:]
        st, sb = size(top, 2), size(bottom, 2)
        st >= sb || (bottom = bottom[end-st+1:end,:])
        st <= sb || (top = top[end-sb+1:end,:])
        @assert size(top) == size(bottom) "top and bottom bit matrices should have equal sizes now"
        global paper = fold == 'y' ? top .| bottom : top' .| bottom'
    end
end

paper_height, paper_width = size(paper)

for line in eachrow(paper)
    for bit in line
        color = bit ? :blue : :light_black
        symbol = bit ? '#' : '.'
        printstyled(symbol; color = color, bold = bit)
        print(" ")
    end
    print("\n")
end

# hardcode the answer for the 'answer_table' on this one
answer = occursin("full", data_file) ? "LRGPRECG" : "SQUARE"
