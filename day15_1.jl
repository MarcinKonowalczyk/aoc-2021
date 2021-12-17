using DelimitedFiles

# data_file = "./data/test/day15_input.txt"
data_file = "./data/full/day15_input.txt"
data = readdlm(data_file, '\n', String)

N, M = (size(data, 1), length(data[1]))

chitons = zeros(Int, (N, M))
for j = 1:N, k = 1:M
    chitons[j, k] = parse(Int, data[j][k])
end

cost_map = fill(typemax(Int), (N, M))
cost_map[CartesianIndex(1,1)] = 0
visited_map = falses((N, M))

neighbours = (CartesianIndex(-1, 0), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(0, 1))

# TODO: try implementing one's own priority queue
#       maybe adapt minheap...?

using DataStructures

begin
    local visit_queue = PriorityQueue{CartesianIndex{2}, Int}(CartesianIndex(1,1)=>0)
    local epoch = 0
    while !isempty(visit_queue)
        current_node = dequeue!(visit_queue)
        visited_map[current_node] = true

        # cost_of_this_node = cost_map[current_node] + chitons[current_node]

        for neighbour in (current_node + x for x in neighbours)
            (checkbounds(Bool, cost_map, neighbour) && !visited_map[neighbour]) || continue
            cost_of_this_node = cost_map[current_node] + chitons[neighbour]

            if cost_of_this_node < cost_map[neighbour]
                cost_map[neighbour] = cost_of_this_node
                # @show visit_queue, neighbour
                enqueue!(visit_queue, neighbour, cost_of_this_node)
            end
        end

        epoch += 1
        if mod(epoch,100) == 0
            done = round(sum(visited_map)/(N*M)*100; digits=1)
            println("$done % done")

            for row in eachrow(visited_map)
                for node in row
                    symbol = node ? 'X' : '.'
                    color = node ? :blue : :light_black
                    printstyled(symbol; color = color);
                end
                print("\n")
            end
        end
    end
end


min_cost = cost_map[end,end]
@show min_cost
answer = min_cost