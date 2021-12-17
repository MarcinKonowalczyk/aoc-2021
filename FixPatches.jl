"""
Patch map, reduce, filter and parse with Fix1 for piping.

Also patches map to use dictionaries as key=>value maps.

Include with:
    (local d = pwd()) in LOAD_PATH || push!(LOAD_PATH, d)
    using FixPatches

"""
module FixPatches

    export dmap

    import Base.map, Base.reduce, Base.filter, Base.parse
    map(f) = Base.Fix1(map, f)
    reduce(f) = Base.Fix1(reduce, f)
    filter(f) = Base.Fix1(filter, f)
    parse(t) = Base.Fix1(parse, t)

    dmap(d::Dict) = Base.Fix1(map, x -> d[x])

end