using DelimitedFiles

# data_file = "./data/test/day10_input.txt"
data_file = "./data/full/day10_input.txt"
lines = readdlm(data_file, ' ', String)

###
# implementation of heap (just for fun)
# hacked out of https://github.com/JuliaCollections/DataStructures.jl

heapleft(i::Integer) = 2i
heapright(i::Integer) = 2i + 1
heapparent(i::Integer) = div(i, 2)

function percolate_up!(h::AbstractArray, i::Integer)
    x = h[i]
    @inbounds while (j = heapparent(i)) >= 1
        x < h[j] || break
        h[i] = h[j]
        i = j
    end
    h[i] = x
end

@inline function heappush!(h::AbstractArray, x)
    push!(h, x)
    percolate_up!(h, length(h))
    return h
end

"""
    circpop!(v, ord::Ordering=Forward)
In-place [`heapify`](@ref).
"""
@inline function circpop!(xs::AbstractArray)
    temp = xs[end]
    for j in length(xs):-1:2
        xs[j] = xs[j-1]
    end
    xs[1] = temp
    return xs
end

function percolate_down!(xs::AbstractArray, i::Integer)
    x = xs[i]
    len::Integer = length(xs)
    @inbounds while (l = heapleft(i)) <= len
        r = heapright(i)
        j = r > len || (xs[l] < xs[r]) ? l : r
        xs[j] < x || break
        xs[i] = xs[j]
        i = j
    end
    xs[i] = x
end

function heappop!(xs::AbstractArray)
    x = popfirst!(xs)
    if !isempty(xs)
        circpop!(xs)
        percolate_down!(xs, 1)
    end
    return x
end

# function heapify!(xs::AbstractArray)
#     for i in heapparent(length(xs)):-1:1
#         percolate_down!(xs, i)
#     end
#     return xs
# end

# function isheap(xs::AbstractArray)
#     for i in 1:div(length(xs), 2)
#         if xs[heapleft(i)] < xs[i] ||
#            (heapright(i) <= length(xs) && xs[heapright(i)] < xs[i])
#             return false
#         end
#     end
#     return true
# end

###

bracket_maping = Dict{Char, Char}('('=>')', '['=>']', '{'=>'}', '<'=>'>')
score_maping = Dict{Char, Integer}(')'=>1, ']'=>2, '}'=>3, '>'=>4)
all_scores = Integer[]::Vector{Integer}

for line in lines
    begin
        expected = Char[]::Vector{Char}
        line_is_valid = true::Bool
        mismatch = (' ',' ')::Tuple{Char, Char}
        for token in line
            # @show token
            if token in keys(bracket_maping)
                push!(expected, bracket_maping[token])
            elseif token in values(bracket_maping)
                top = pop!(expected)
                line_is_valid = (top == token)::Bool
                if !line_is_valid
                    mismatch = (top, token)::Tuple{Char, Char}
                    break
                end
            else
                error("Unknown token $token")
            end
            # @show expected
        end
    end

    if line_is_valid
        @show join(reverse(expected),"")
        let score = 0::Int
            for character in reverse(expected)
                score *= 5
                score += score_maping[character]
            end
            @show score
            heappush!(all_scores, score)
        end
        # line_score = score_maping[mismatch[2]]
        # println("Expected '" * mismatch[1] * "' but got '" * mismatch[2] * "' for $line_score points!")
        # global score += line_score
    end
end

N = length(all_scores)
@assert mod(N,2) == 1 "Invliad number of scores (must be odd)"

for _ in 1:floor(N/2)
    heappop!(all_scores)
end

middle_score = heappop!(all_scores)
@show middle_score

answer = middle_score