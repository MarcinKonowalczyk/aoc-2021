using DelimitedFiles

data_file = "./data/test/day12_input.txt"
# data_file = "./data/full/day12_input.txt"
connections = readdlm(data_file, '-', String)

# Patch + and - to work as set difference
import Base.-, Base.+
@inline +(s1::AbstractSet{T}, s2::AbstractSet{T}) where {T} = union(s1, s2)
@inline +(s1::AbstractSet{T}, s2::T) where {T} = union(s1, Set{T}([s2]))
@inline -(s1::AbstractSet{T}, s2::AbstractSet{T}) where {T} = setdiff(s1, s2)
@inline -(s1::AbstractSet{T}, s2::T) where {T} = setdiff(s1, Set{T}([s2]))

# Patch map, reduce and filter with Fix1 for piping


const Cave = String

# build the cave system
caves = Dict{Cave,Set{Cave}}([])
for (cave1, cave2) in eachrow(connections)
    (cave1 in keys(caves)) || (caves[cave1] = Set{Cave}([]))
    (cave2 in keys(caves)) || (caves[cave2] = Set{Cave}([]))

    push!(caves[cave1], cave2)
    push!(caves[cave2], cave1)
end

issmall(cave) = islowercase(cave[1])

function all_subpaths(
    current_cave::Cave,
    already_visited::Set{Cave},
)::Vector{Vector{String}}
    routes = caves[current_cave] - already_visited
    if current_cave == "end" || isempty(routes)
        # @show current_cave
        return [[]]
    end
    subpaths = []
    for cave in routes
        for subpath in all_subpaths(
            cave,
            issmall(current_cave) ? already_visited + current_cave : already_visited,
        )
            push!(subpath, cave)
            push!(subpaths, subpath)
        end
    end
    return subpaths
end

paths_tree = all_subpaths("start", Set{Cave}([]))

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
