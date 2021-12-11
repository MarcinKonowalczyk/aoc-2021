using DelimitedFiles
using BenchmarkTools

# data_file = "./data/test/day11_input.txt"
data_file = "./data/full/day11_input.txt"
data = readdlm(data_file, ' ', String)

N, M = (size(data, 1), length(data[1]))

octopi = zeros(Int, (N+2, M+2))
for j in 1:N, k in 1:M
    octopi[j+1, k+1] = parse(Int, data[j][k])
end

@inline function clip_pad!(octopi)
    @inbounds octopi[:,1] .= 0
    @inbounds octopi[:,end] .= 0
    @inbounds octopi[1,:] .= 0
    @inbounds octopi[end,:] .= 0
end

function print_octopi(octopi)
    for j in 1:N
        for k in 1:M
            octopus = octopi[j+1, k+1]
            printstyled(octopus; color = octopus == 0 ? :blue : :light_black, bold = (octopus == 0))
        end
        print("\n")
    end
    print("\n")
end

step = 0
while true
    all_flashes = falses(size(octopi))::BitMatrix

    new_flashes = (octopi .> 9)::BitMatrix
    all_flashes .|= new_flashes

    @inbounds while any(new_flashes)
        # flash all octopi
        for octopus in findall(new_flashes)
            octopi[octopus[1]-1:octopus[1]+1, octopus[2]-1:octopus[2]+1] .+= 1
        end
        # clip_pad!(octopi)  # not actually needed here, because

        new_flashes = (octopi .> 9) .& (.!all_flashes)
        all_flashes .|= new_flashes
    end

    octopi[all_flashes] .= 0

    if sum(all_flashes) == N*M
        break
    end

    if mod(step, 20) == 0
        println("After step $step:")
        print_octopi(octopi)
    end

    # prepare for the next step
    octopi .+= 1
    clip_pad!(octopi)

    global step += 1
end

println("After final step $step:")
print_octopi(octopi)

# @show step

answer = step