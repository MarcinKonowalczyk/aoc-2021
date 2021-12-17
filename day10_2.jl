using DelimitedFiles

data_file = "./data/test/day10_input.txt"
# data_file = "./data/full/day10_input.txt"
lines = readdlm(data_file, ' ', String)

(d = pwd()) in LOAD_PATH || push!(LOAD_PATH, d)
using Heap

bracket_maping = Dict{Char,Char}('(' => ')', '[' => ']', '{' => '}', '<' => '>')
score_maping = Dict{Char,Integer}(')' => 1, ']' => 2, '}' => 3, '>' => 4)
all_scores = Integer[]::Vector{Integer}

for line in lines
    begin
        expected = Char[]::Vector{Char}
        line_is_valid = true::Bool
        mismatch = (' ', ' ')::Tuple{Char,Char}
        for token in line
            # @show token
            if token in keys(bracket_maping)
                push!(expected, bracket_maping[token])
            elseif token in values(bracket_maping)
                top = pop!(expected)
                line_is_valid = (top == token)::Bool
                if !line_is_valid
                    mismatch = (top, token)::Tuple{Char,Char}
                    break
                end
            else
                error("Unknown token $token")
            end
            # @show expected
        end
    end

    if line_is_valid
        @show join(reverse(expected), "")
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
@assert mod(N, 2) == 1 "Invliad number of scores (must be odd)"

for _ = 1:floor(N / 2)
    heappop!(all_scores)
end

middle_score = heappop!(all_scores)
@show middle_score

answer = middle_score
