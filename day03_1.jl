using DelimitedFiles

data_file = "./data/test/day03_input.txt"
# data_file = "./data/full/day03_input.txt"
data = readdlm(data_file, String)

B = zeros(Bool, size(data, 1), length(data[1]))
for (ri, row) in enumerate(data)
    for (ci, char) in enumerate(row)
        B[ri, ci] = parse(Bool, char)
    end
end

col_ones = sum(B, dims = 1)
col_zeros = sum(.~B, dims = 1)

gamma_bits = col_ones .> col_zeros
epsilon_bits = .!gamma_bits

bits2int = Base.Fix1(sum, ((i, x),) -> x << (i - 1)) ∘ enumerate ∘ reverse

@show gamma_bits
@show epsilon_bits
gamma = bits2int(gamma_bits)
epsilon = bits2int(epsilon_bits)
power_consumption = gamma * epsilon

@show gamma, epsilon
@show power_consumption
answer = power_consumption
