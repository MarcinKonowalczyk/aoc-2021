using DelimitedFiles

# data_file = "./data/day3_input.txt"
data_file = "./data_full/day3_input.txt"
data = readdlm(data_file, String)

B = zeros(Bool, size(data,1), length(data[1]))
for (ri, row) in enumerate(data)
    for (ci, char) in enumerate(row)
        B[ri, ci] = parse(Bool, char)
    end
end

col_ones = sum(B, dims=1)
col_zeros = sum(.~B, dims=1)

gamma_bits = col_ones .> col_zeros
epsilon_bits = .~gamma_bits

bits_to_int(bits) = sum(((i, x),) -> x << (i-1), enumerate(reverse(bits)))
gamma = bits_to_int(gamma_bits)
epsilon = bits_to_int(epsilon_bits)

print(gamma * epsilon)