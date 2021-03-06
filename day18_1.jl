using DelimitedFiles

# data_file = "./data/test/day18_input.txt"
data_file = "./data/full/day18_input.txt"
data = readdlm(data_file, '\n', String; skipblanks = false)[:]

data = [line for line in data if !startswith(line, "#")] # skip commented lines

begin
    sequences = Vector{Vector{String}}([[]])
    for line in data
        isempty(line) ? push!(sequences, []) : push!(sequences[end], line)
    end
    sequences = [s for s in sequences if !isempty(s)]
end

###

(local d = pwd()) in LOAD_PATH || push!(LOAD_PATH, d)
using FixPatches

# Overload plus with pair addition and tilde with lossy pair concatenation
import Base.+, Base.~, Base.*
+(pair::Pair, value::Int) = pair.first => (pair.second + value)
+(value::Int, pair::Pair) = (value + pair.first) => pair.second
+(p1::Pair, p2::Pair) = (p1.first + p2.first) => (p2.second + p1.second) # note: the order matters since addition of pairs is not commutative
+(n::Nothing, value::Int) = nothing
+(value::Int, n::Nothing) = nothing
~(p1::Pair, p2::Pair) = p1.first => p2.second
# *(p1::Pair, p2::Pair) = p1=>p2
# ~(n::Nothing, p2::Pair) = nothing => p2.second
# ~(p1::Pair, n::Nothing) = p1.first => nothing

pairify(x) = x isa Vector ? pairify(first(x)) => pairify(last(x)) : x

sequences =
    sequences |> map(map(eval ∘ Meta.parse)) |> map(map(pairify)) |> Vector{Vector{Pair}}

function reduce_step(pair::Pair, depth::Int = 0, context = nothing => nothing)
    depth <= 4 || error("This should not happen")
    if depth == 4
        context, pair = context + pair, 0
    else
        old_first, old_second = pair
        new_first, new_context = reduce_step(pair.first, depth + 1, context ~ pair)
        if new_first != old_first
            pair = new_first => new_context.second
            context = new_context.first => context.second
        else
            new_second, new_context = reduce_step(pair.second, depth + 1, pair ~ context)
            if new_second != old_second
                pair = new_context.first => new_second
                context = context.first => new_context.second
            end
        end
    end
    return pair, context
end

reduce_step(number::Int, depth::Int = 0, context = nothing => nothing) =
    (number < 10 || depth >= 0) ? number : fld(number, 2) => cld(number, 2), context

# i know i should call this funciton something else, but lol -M
import Base.reduce
function reduce(number::Pair)
    # println("reducing $number")
    counter = 0
    while true
        # @show number
        reduced_number, context = reduce_step(number, 0)
        @assert context == (nothing => nothing) "at top level context should be nothing=>nothing"
        if reduced_number != number
            mod(counter, 20) == 0 && println("$counter explode step")
        else
            reduced_number, context = reduce_step(number, -5)
            @assert context == (nothing => nothing) "at top level context should be nothing=>nothing"
            if mod(counter, 20) == 0 && reduced_number != number
                println("$counter split step")
            end
        end
        reduced_number == number && break
        # @show reduced_number
        number = reduced_number
        counter += 1
    end
    return number
end

reduce(p1::Pair, p2::Pair) = reduce(p1 => p2)

flatten(pair::Pair) = (flatten(pair.first)..., flatten(pair.second)...)
flatten(number::Int) = number

magnitude(pair::Pair) = 3 * magnitude(pair.first) + 2 * magnitude(pair.second)
magnitude(number::Int) = number


# TODO: Make this code faster(!)
#       Maybe stop using pairs?
#       Try passigng out a value which indicates whether a change has been made, as opposed to comparing pairs


# using BenchmarkTools

# test = sequences[end]
# test |> reduce(reduce)
# @benchmark test |> reduce(reduce)

magnitudes = Vector{Int}()
for sequence in sequences
    @show sequence
    # probably doesnt need the initial map(reduce) and final reduce
    result = sequence |> map(reduce) |> reduce(reduce) |> reduce
    # @show result
    m = magnitude(result)
    @show m
    push!(magnitudes, m)
end

answer = length(magnitudes) == 1 ? magnitudes[1] : magnitudes

@show answer
