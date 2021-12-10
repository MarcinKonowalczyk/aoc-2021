using DelimitedFiles

# data_file = "./data/test/day10_input.txt"
data_file = "./data/full/day10_input.txt"
lines = readdlm(data_file, ' ', String)


bracket_maping = Dict{Char, Char}('('=>')', '['=>']', '{'=>'}', '<'=>'>')
score_maping = Dict{Char, Int64}(')'=>3, ']'=>57, '}'=>1197, '>'=>25137)
score = 0::Int64

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

    if !line_is_valid
        line_score = score_maping[mismatch[2]]
        println("Expected '" * mismatch[1] * "' but got '" * mismatch[2] * "' for $line_score points!")
        global score += line_score
    end
end

@show score

answer = score