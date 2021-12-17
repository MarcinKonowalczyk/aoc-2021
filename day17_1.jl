using DelimitedFiles

# data_file = "./data/test/day17_input.txt"
data_file = "./data/full/day17_input.txt"
data = readdlm(data_file, ' ', String)

(local d = pwd()) in LOAD_PATH || push!(LOAD_PATH, d)
using FixPatches
using Heap

proc = map(parse(Int)) ∘ (x->split(x,"..")) ∘ (x->x[3:end]) ∘ (x->split(x,",")[1])
x, y = proc(data[3]), proc(data[4])
y = reverse(y)

inbox(p) = (p[1] >= x[1]) && (p[1] <= x[2]) && (p[2] <= y[1]) && (p[2] >= y[2])

function test_shot(v::Tuple; show_trajectory::Bool=false)
    position = [0, 0]
    velocity = [v[1], v[2]]

    trajectory = [Tuple(position)]
    while true
        # @show position, velocity
        
        hit = inbox(position)
        miss = position[1] > x[2] || position[2] < y[2]

        if show_trajectory
            all_points = union(trajectory, [(x[1],y[1]), (x[2],y[2])])
            x_range = all_points |> reduce((x,y)->(min(x[1], y[1]),max(x[1], y[1])))
            y_range = all_points |> reduce((x,y)->(min(x[2], y[2]),max(x[2], y[2]))) |> reverse
            for y in y_range[1]:-1:y_range[2]
                for x in x_range[1]:x_range[2]
                    if (x,y) in trajectory
                        printstyled("#"; color = :blue, bold = true)
                    elseif inbox([x, y])
                        color = hit ? :green : miss ? :red : :yellow
                        printstyled("T"; color = color)
                    else
                        printstyled("."; color = :light_black )
                    end
                end
                print("\n")
            end
        end

        if hit
            return true, trajectory
        elseif miss
            return false, trajectory
        end

        position[1] += velocity[1]
        position[2] += velocity[2]
        if velocity[1] > 0
            velocity[1] -= 1
        elseif velocity[1] < 0
            velocity[1] += 1
        end
        velocity[2] -= 1

        push!(trajectory, Tuple(position))
    end
end

# test_shot((7,2); show_trajectory = true)

N, M = 100, 100

candidates = []

for vx = 1:100, vy = 1:100
    hit, trajectory = test_shot((vx, vy))
    if hit
        max_height = trajectory |> reduce((x,y)->(nothing, max(x[2],y[2]))) |> last
        heappush!(candidates, -max_height=>(vx,vy))
    end
end

highest = heappop!(candidates)

max_height = -highest.first
initial_velocoty = highest.second

@show max_height
@show initial_velocoty

answer = max_height