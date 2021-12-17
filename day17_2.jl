using DelimitedFiles

# data_file = "./data/test/day17_input.txt"
data_file = "./data/full/day17_input.txt"
data = readdlm(data_file, ' ', String)

(local d = pwd()) in LOAD_PATH || push!(LOAD_PATH, d)
using FixPatches, Heap

proc = map(parse(Int)) ∘ (x->split(x,"..")) ∘ (x->x[3:end]) ∘ (x->split(x,",")[1])
x, y = proc(data[3]), proc(data[4])
y = reverse(y)
@show x, y

inbox(p) = p[1] >= x[1] && p[1] <= x[2] && p[2] <= y[1] && p[2] >= y[2]
toofar(p) = p[1] > x[2] || p[2] < y[2]

function test_shot(v::Tuple)
    position, velocity = [0, 0], [v[1], v[2]]
    trajectory = [Tuple(position)]
    while true
        inbox(position) && return true, trajectory
        toofar(position) && return false, trajectory
        position += velocity
        velocity -= [sign(velocity[1]), 1]
        push!(trajectory, Tuple(position))
    end
end

candidates = Vector{Pair{Int,Tuple{Int,Int}}}()
# Pick the range of x's and y's to try based on the position of the target region
for vx = 1:maximum(x), vy = minimum(y):(-minimum(y))
    hit, trajectory = test_shot((vx, vy))
    if hit
        max_height = trajectory |> reduce((x,y)->(nothing, max(x[2],y[2]))) |> last
        heappush!(candidates, -max_height=>(vx,vy))
    end
end

number_of_candidates = length(candidates)
@show number_of_candidates

answer = number_of_candidates
