using DelimitedFiles

data_file = "./data/day3_input.txt"
# data_file = "./data_full/day3_input.txt"
data = readdlm(data_file, String)

B = zeros(Bool, size(data,1), length(data[1]))
for (ri, row) in enumerate(data)
    for (ci, char) in enumerate(row)
        B[ri, ci] = parse(Bool, char)
    end
end

function find_bit_criterion(B, switch)
    mask = trues(size(B,1))
    for col in eachcol(B)
        let col = col .& mask
            mask .&= (switch ⊻ (2*sum(col) >= sum(mask))) ? col : .!col
        end
        sum(mask) <= 1 ? break : undef
    end
    return findall(mask)[1]
end

bits_to_int(bits) = sum(((i, x),) -> x << (i-1), enumerate(reverse(bits)))

oxygen_I, co2_I = find_bit_criterion(B, true), find_bit_criterion(B, false)
oxygen_rating, co2_rating = bits_to_int(B[oxygen_I,:]), bits_to_int(B[co2_I,:])
life_support_rating = oxygen_rating * co2_rating

@show oxygen_rating, co2_rating
@show life_support_rating
