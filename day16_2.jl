using DelimitedFiles

data_file = "./data/test/day16_input.txt"
# data_file = "./data/full/day16_input.txt"
data = readdlm(data_file, '\n', String)[:]

(local d = pwd()) in LOAD_PATH || push!(LOAD_PATH, d)
using FixPatches

hex2bits = BitVector ∘ map(parse(Bool)) ∘ collect ∘ join ∘ map(bitstring) ∘ hex2bytes
bits2int = Base.Fix1(sum, ((i, x),) -> x << (i - 1)) ∘ enumerate ∘ reverse

"""
Read n bits from the bit stream, and push the pointer along the way.
The pointer is the only hign which gets modified.
"""
function read_n_bits(bits::BitVector, pointer::Int, n::Int)
    len = length(bits)
    @assert (pointer + n - 1) <= len "$pointer + $n larger than the length of the bits array! ($len)"
    bits = bits[pointer:(pointer+n-1)]
    pointer += n
    return bits, pointer
end

function parse_packet(bits::BitVector, pointer::Int = 1)::Tuple{Tuple{Int,Int,Any},Int}
    version, pointer = read_n_bits(bits, pointer, 3)
    version = bits2int(version)
    typeid, pointer = read_n_bits(bits, pointer, 3)
    typeid = bits2int(typeid)

    if typeid == 4
        println("literal packet  | v$version id$typeid")
        value, pointer = parse_literal_packet(bits, pointer)
    elseif typeid <= 7
        println("operator packet | v$version id$typeid")
        value, pointer = parse_operator_packet(bits, pointer)
    else
        error("Unknown typeid ($typeid)")
    end
    return (version, typeid, value), pointer
end

"""
Parse a literal packet out of the bit stream
"""
function parse_literal_packet(bits::BitVector, pointer::Int)::Tuple{Int,Int}
    value = BitVector([])
    indicator_bit = true
    while indicator_bit
        group, pointer = read_n_bits(bits, pointer, 5)
        indicator_bit = group[1]
        value = vcat(value, group[2:end])
    end
    value = bits2int(value)::Int
    return value, pointer
end

"""
Parse an operator packet out of the bit stream
"""
function parse_operator_packet(bits::BitVector, pointer::Int)::Tuple{Vector,Int}
    lengthid, pointer = read_n_bits(bits, pointer, 1)
    lengthid = lengthid[1]

    subvalues = []::Vector
    length, pointer = read_n_bits(bits, pointer, lengthid ? 11 : 15)
    length = bits2int(length)

    length_tally = 0
    while length_tally < length
        value, new_pointer = parse_packet(bits, pointer)
        push!(subvalues, value)
        length_tally += lengthid ? 1 : new_pointer - pointer
        pointer = new_pointer
    end

    return subvalues, pointer
end

function apply_operators(value::Tuple)::Int
    _, typeid, subvalue = value
    subvalue = apply_operators(subvalue)
    if typeid == 0
        return sum(subvalue)
    elseif typeid == 1
        return prod(subvalue)
    elseif typeid == 2
        return minimum(subvalue)
    elseif typeid == 3
        return maximum(subvalue)
    elseif typeid == 4
        return subvalue
    elseif typeid == 5
        @assert length(subvalue) == 2
        return Int(subvalue[1] > subvalue[2])
    elseif typeid == 6
        @assert length(subvalue) == 2
        return Int(subvalue[1] < subvalue[2])
    elseif typeid == 7
        @assert length(subvalue) == 2
        return Int(subvalue[1] == subvalue[2])
    else
        error("unknown typeid ($typeid)")
    end
end

apply_operators(values::Vector)::Vector{Int} = [apply_operators(value) for value in values]
apply_operators(value::Int)::Int = value

process = Int ∘ apply_operators ∘ first ∘ parse_packet ∘ hex2bits
evals = map(process, data)
@show evals

answer = length(evals) == 1 ? first(evals) : evals
