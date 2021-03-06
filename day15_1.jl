using DelimitedFiles

# data_file = "./data/test/day15_input.txt"
data_file = "./data/full/day15_input.txt"
data = readdlm(data_file, '\n', String)

N, M = (size(data, 1), length(data[1]))

chitons = zeros(Int, (N, M))
for j = 1:N, k = 1:M
    chitons[j, k] = parse(Int, data[j][k])
end

# Run Dijkstra's shortest paths algorithm
cost_map = fill(typemax(Int), (N, M))
cost_map[CartesianIndex(1, 1)] = 0
visited_map = falses((N, M))

neighbours = (
    CartesianIndex(-1, 0),
    CartesianIndex(1, 0),
    CartesianIndex(0, -1),
    CartesianIndex(0, 1),
)

(local d = pwd()) in LOAD_PATH || push!(LOAD_PATH, d)
using Heap

begin
    local visit_queue = Vector{Pair{CartesianIndex{2},Int}}([CartesianIndex(1, 1) => 0])
    local comp_fun(x, y) = x.second < y.second
    local epoch = 0
    while !isempty(visit_queue)
        current_node = first(heappop!(visit_queue, comp_fun))
        current_node == CartesianIndex(N, M) && break
        visited_map[current_node] && continue
        visited_map[current_node] = true

        for neighbour in (current_node + x for x in neighbours)
            (checkbounds(Bool, cost_map, neighbour) && !visited_map[neighbour]) || continue
            cost_of_neighbour = cost_map[current_node] + chitons[neighbour]
            if cost_of_neighbour < cost_map[neighbour]
                cost_map[neighbour] = cost_of_neighbour
                heappush!(visit_queue, neighbour => cost_of_neighbour, comp_fun)
            end
        end

        epoch += 1
        if mod(epoch, 100) == 0
            done = round(sum(visited_map) / (N * M) * 100; digits = 1)
            println("$done % done")

            # for row in eachrow(visited_map)
            #     for node in row
            #         symbol = node ? 'X' : '.'
            #         color = node ? :blue : :light_black
            #         printstyled(symbol; color = color);
            #     end
            #     print("\n")
            # end
        end
    end
end


min_cost = cost_map[end, end]
@show min_cost
answer = min_cost
