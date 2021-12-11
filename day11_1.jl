using DelimitedFiles

data_file = "./data/test/day11_input.txt"
# data_file = "./data/full/day11_input.txt"
data = readdlm(data_file, ' ', String)

N, M = (size(data, 1), length(data[1]))

octopi = zeros(Int, (N + 2, M + 2))
for j = 1:N, k = 1:M
    octopi[j+1, k+1] = parse(Int, data[j][k])
end

total_flashes = 0

for step = 0:100
    all_flashes = falses(size(octopi))::BitMatrix

    new_flashes = (octopi .> 9)::BitMatrix
    all_flashes .|= new_flashes

    @inbounds while any(new_flashes)
        # flash all octopi
        @inbounds for octopus in findall(new_flashes)
            octopi[octopus[1]-1:octopus[1]+1, octopus[2]-1:octopus[2]+1] .+= 1
        end
        # preserve padding at 0
        octopi[:, 1] .= 0
        octopi[:, end] .= 0
        octopi[1, :] .= 0
        octopi[end, :] .= 0

        new_flashes = (octopi .> 9) .& (.!all_flashes)
        all_flashes .|= new_flashes
    end

    octopi[all_flashes] .= 0
    global total_flashes += sum(all_flashes)

    if mod(step, 10) == 0
        println("After step $step:")
        for j = 1:N
            for k = 1:M
                octopus = octopi[j+1, k+1]
                printstyled(
                    octopus;
                    color = octopus == 0 ? :blue : :light_black,
                    bold = (octopus == 0),
                )
            end
            print("\n")
        end
        print("\n")
    end

    octopi .+= 1
end

@show total_flashes

answer = total_flashes
