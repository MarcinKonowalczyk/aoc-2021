#! julia

# check that we're in the project root
root = pwd()
if split(root, '/')[end] != "aoc-2021"
    error("run this script from the root folder")
end

# check that data/full exists
full_data_dir = joinpath(root, "data/full")
if !ispath(full_data_dir)
    error("could not locate the full data direcotry (" * full_data_dir * ")")
end

# make reduced data directory if it does not exist
data_dir = joinpath(root, "data/reduced")
if !ispath(data_dir)
    mkdir(data_dir)
end

full_data_dir_content = readdir(full_data_dir)
data_dir_content = readdir(data_dir)

for f in full_data_dir_content
    if !(f in data_dir_content)
        lines = open(joinpath(full_data_dir, f), "r") do io
            return [readline(io) for _ = 1:100]
        end
        println("writng ./data/reduced/" * f)
        open(joinpath(data_dir, f), "w") do io
            for l in lines[1:end-1]
                write(io, l * "\n")
            end
            write(io, lines[end])
        end
    else
        println("./data/reduced/" * f * " already exists")
    end
end
