using DelimitedFiles

# data_file = "./data/test/day18_input.txt"
data_file = "./data/full/day18_input.txt"
data = readdlm(data_file, '\n', String; skipblanks=false)[:]

data = [line for line in data if !startswith(line,"#")] # skip commented lines

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
@nospecialize
+(pair::Pair, value::Int) = pair.first => (pair.second + value)
+(value::Int, pair::Pair) = (value + pair.first) => pair.second
+(p1::Pair, p2::Pair) = (p1.first + p2.first) => (p2.second + p1.second) # note: the order matters since addition of pairs is not commutative
+(n::Nothing, value::Int) = nothing
+(value::Int, n::Nothing) = nothing
~(p1::Pair, p2::Pair) = p1.first => p2.second
@specialize
# *(p1::Pair, p2::Pair) = p1=>p2
# ~(n::Nothing, p2::Pair) = nothing => p2.second
# ~(p1::Pair, n::Nothing) = p1.first => nothing

pairify(x) = x isa Vector ? pairify(first(x)) => pairify(last(x)) : x

sequences = sequences |> map(map(eval ∘ Meta.parse)) |> map(map(pairify)) |> Vector{Vector{Pair}}

function reduce_step(@nospecialize(pair::Pair), depth::Int=0, @nospecialize(context=nothing=>nothing))
    # depth <= 4 || error("This should not happen")
    changed = false
    if depth == 4
        context = context + pair
        pair = 0
        changed = true
    else
        # old_first, old_second = pair
        new_first, new_context, changed = reduce_step(pair.first, depth+1, context~pair)
        if changed
            pair = new_first=>new_context.second
            context = new_context.first=>context.second
        else
            new_second, new_context, changed = reduce_step(pair.second, depth+1, pair~context)
            if changed
                pair = new_context.first=>new_second
                context = context.first=>new_context.second
            end
        end
    end
    return pair, context, changed
end

reduce_step(number::Int, depth::Int=0, context=nothing=>nothing) = (temp = (number < 10 || depth >= 0)) ? number : fld(number,2)=>cld(number,2), context, !temp

# i know i should call this funciton something else, but lol -M
import Base.reduce
function reduce(@nospecialize number::Pair)
    # println("reducing $number")
    counter = 0
    while true
        # @show number
        reduced_number, context, changed = reduce_step(number, 0)
        # @assert context == (nothing=>nothing) "at top level context should be nothing=>nothing"
        if changed
            # mod(counter, 10)==0 && println("$counter explode step")
        else
            reduced_number, context, changed = reduce_step(number, -5)
            # @assert context == (nothing=>nothing) "at top level context should be nothing=>nothing"
            # mod(counter, 10)==0 && changed && println("$counter split step")
        end
        reduced_number == number && break
        # @show reduced_number
        number = reduced_number
        counter += 1
    end
    return number
end

reduce(p1::Pair, p2::Pair) = reduce(p1=>p2)

flatten(pair::Pair) = (flatten(pair.first)..., flatten(pair.second)...)
flatten(number::Int) = number

magnitude(pair::Pair) = 3*magnitude(pair.first) + 2*magnitude(pair.second)
magnitude(number::Int) = number

# TODO: is it the case that product of large magnitude numbers is also large??
#       is there a relationship between the mags of the individual numbers and mag of the product?

magnitudes = Vector{Int}()
for sequence in sequences
    length(sequence) > 1 || continue
    @show sequence

    max_m = 0
    N = length(sequence)*length(sequence)
    for (pri, (s1, s2)) in enumerate(Iterators.product(sequence, sequence))
        println("--- test $pri / $N ---")
        mag = (s1, s2) |> reduce(reduce) |> magnitude
        if mag > max_m
            println("new magnituve $mag found > $max_m")
            max_m = mag
        else
            println("$mag < $max_m")
        end
    end
    push!(magnitudes, max_m)
end

answer = length(magnitudes) == 1 ? magnitudes[1] : magnitudes

@show answer