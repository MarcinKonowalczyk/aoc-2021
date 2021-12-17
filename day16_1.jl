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
    @assert (pointer+n-1) <= len "$pointer + $n larger than the length of the bits array! ($len)"
    bits = bits[pointer:(pointer+n-1)]
    pointer += n
    return bits, pointer
end

function parse_packet(bits::BitVector, pointer::Int)
    version, new_pointer = read_n_bits(bits, pointer, 3)
    version = bits2int(version)
    typeid, _ = read_n_bits(bits, new_pointer, 3)
    typeid = bits2int(typeid)

    if typeid == 4
        println("literal packet | version: $version | typeid: $typeid")
        return parse_literal_packet(bits, pointer)
    else
        println("operator packet | version: $version | typeid: $typeid")
        return parse_operator_packet(bits, pointer)
    end
end

"""
Parse a literal packet out of the bit stream
"""
function parse_literal_packet(bits::BitVector, pointer::Int)
    version, pointer = read_n_bits(bits, pointer, 3)
    version = bits2int(version)
    typeid, pointer = read_n_bits(bits, pointer, 3)
    typeid = bits2int(typeid)
    @assert typeid == 4 "typeid ($typeid) != 4. Not a literal packet."

    # Read groups until a terminal one is found
    value = BitVector([])
    indicator_bit = true
    while indicator_bit
        group, pointer = read_n_bits(bits, pointer, 5)
        indicator_bit = group[1]
        value = vcat(value, group[2:end])
    end
    value = bits2int(value)

    return (version, typeid, value), pointer
end

"""
Parse an operator packet out of the bit stream
"""
function parse_operator_packet(bits::BitVector, pointer::Int)
    version, pointer = read_n_bits(bits, pointer, 3)
    version = bits2int(version)
    typeid, pointer = read_n_bits(bits, pointer, 3)
    typeid = bits2int(typeid)
    @assert typeid != 4 "typeid ($typeid) == 4. This is a literal packet, not an operator."
    
    lengthid, pointer = read_n_bits(bits, pointer, 1)
    lengthid = lengthid[1]
    subvalues = []
    if !lengthid
        length, pointer = read_n_bits(bits, pointer, 15)
        length = bits2int(length)
        
        bits_read = 0
        while bits_read < length
            value, new_pointer = parse_packet(bits, pointer)
            bits_read += (new_pointer - pointer)
            pointer = new_pointer
            push!(subvalues, value)
        end
    else
        n_subpackets, pointer = read_n_bits(bits, pointer, 11)
        n_subpackets = bits2int(n_subpackets)

        packets_read = 0
        while packets_read < n_subpackets
            value, pointer = parse_packet(bits, pointer)
            packets_read += 1
            push!(subvalues, value)
        end
    end
    
    return (version, typeid, subvalues), pointer
end

function version_sum(value::Tuple)
    version, typeid, subvalue = value
    if typeid == 4
        return version
    else
        return version + version_sum(subvalue)
    end
end

version_sum(values::Vector) = sum(version_sum(value) for value in values)



sums = Vector{Int}([])
for line in data
    bits = hex2bits(line)
    n_bits = length(bits)

    value, pointer = parse_packet(bits, 1)
    # @show value

    push!(sums, version_sum(value))
end

@show sums

answer = length(sums) == 1 ? first(sums) : sums