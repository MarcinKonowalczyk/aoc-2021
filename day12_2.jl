using DelimitedFiles

# data_file = "./data/test/day12_input.txt"
data_file = "./data/full/day12_input.txt"
connections = readdlm(data_file, '-', String)

# Patch + and - to work as set difference
import Base.-, Base.+
@inline +(s1::AbstractSet{T}, s2::AbstractSet{T}) where {T} = union(s1, s2)
@inline +(s1::AbstractSet{T}, s2::T) where {T} = union(s1, Set{T}([s2]))
@inline -(s1::AbstractSet{T}, s2::AbstractSet{T}) where {T} = setdiff(s1, s2)
@inline -(s1::AbstractSet{T}, s2::T) where {T} = setdiff(s1, Set{T}([s2]))

# Patch map, reduce and filter with Fix1 for piping
import Base.map, Base.reduce, Base.filter
map(f) = Base.Fix1(map, f)
reduce(f) = Base.Fix1(reduce, f)
filter(f) = Base.Fix1(filter, f)

const Cave = String

# build the cave system
const caves = Dict{Cave,Set{Cave}}([])
for (cave1, cave2) in eachrow(connections)
    (cave1 in keys(caves)) || (caves[cave1] = Set{Cave}([]))
    (cave2 in keys(caves)) || (caves[cave2] = Set{Cave}([]))

    push!(caves[cave1], cave2)
    push!(caves[cave2], cave1)
end

issmall(cave) = islowercase(cave[1])

function all_subpaths(
    current_cave::Cave,
    visited::Set{Cave},
    double_visit_done::Bool,
)::Vector{Vector{String}}
    routes = caves[current_cave] - visited - "start"
    (current_cave != "end" && !isempty(routes)) || return [[]]

    # Recursively get all the spossible subpaths
    subpaths = Set{Vector{String}}([]) # use set to add only unique paths
    new_visited = issmall(current_cave) ? visited + current_cave : visited
    for cave in routes, subpath in all_subpaths(cave, new_visited, double_visit_done)
        push!(subpath, cave)
        push!(subpaths, subpath)
    end

    # Double visit oneself
    if issmall(current_cave) && !double_visit_done
        for cave in routes, subpath in all_subpaths(cave, visited, true)
            push!(subpath, cave)
            push!(subpaths, subpath)
        end
    end
    return collect(subpaths)
end

paths_tree = all_subpaths("start", Set{Cave}([]), false)

paths = paths_tree |> filter(x -> x[1] == "end") |> map(reverse) |> map(x -> x[1:end-1])

number_of_paths = length(paths)

if number_of_paths < 100
    for path in paths
        println("start,", join(path, ","), ",end")
    end
else
    for path in paths[1:10]
        println("start,", join(path, ","), ",end")
    end
    println("...")
    for path in paths[end-10:end]
        println("start,", join(path, ","), ",end")
    end
end

@show number_of_paths

answer = number_of_paths
