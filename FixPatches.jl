"""
Patch map, reduce, filter and parse with Fix1 for piping.

Also patches map to use dictionaries as key=>value maps.

Include with:
    (local d = pwd()) in LOAD_PATH || push!(LOAD_PATH, d)
    using FixPatches

"""
module FixPatches

export dmap

import Base.map, Base.reduce, Base.filter
map(f::Function) = Base.Fix1(map, f)
filter(f::Function) = Base.Fix1(filter, f)
reduce(f::Function) = Base.Fix1(reduce, f)

import Base.parse, Base.split
parse(t) = Base.Fix1(parse, t)

dmap(d::Dict) = Base.Fix1(map, x -> d[x])

end
