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

@inline function heappush!(heap::AbstractArray, x)
    push!(heap, x)
    # pull the tail of the heap through it to restore the heap property
    position = length(heap)
    @inbounds while (new_position = heapparent(position)) >= 1
        x < heap[new_position] || break
        heap[position] = heap[new_position]
        position = new_position
    end
    heap[position] = x
    return heap
end

function heappop!(heap::AbstractArray)
    p = popfirst!(heap)
    N = length(heap)
    if N > 0
        let x = heap[end]
            # circshift heap forward by one
            for i in N:-1:2
                heap[i] = heap[i-1]
            end
            # push the tail of the heap through it to restore the heap property
            position = 1
            @inbounds while (left = heapleft(position)) <= N
                right = heapright(position)
                new_position = right > N || (heap[left] < heap[right]) ? left : right
                heap[new_position] < x || break
                heap[position] = heap[new_position]
                position = new_position
            end
            heap[position] = x
        end
    end
    return p
end

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