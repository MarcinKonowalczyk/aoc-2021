#! julia

# check that we're in the project root
root = pwd()
if split(root, '/')[end] != "aoc-2021"
    error("run this script from the project root folder")
end

function switch_data_source!(
    source::Vector{String},
    day_string::String,
    subfolder::String,
    safe = true,
)
    """Switch the data folder in the source file"""
    for i = 1:length(source)
        line = source[i]
        if !occursin(r"\s*#.*", line)
            m = match(
                r"(?'other_pre'.*)\"(?'string_pre'\.\/)(?'folder'.*)\/(?'subfolder'.*)\/day" *
                day_string *
                r"_input.txt\"(?'other_post'.*)",
                line,
            )
            if (m !== nothing)
                if safe
                    # Try to reconstruct the source line to make sure the regex matches well
                    reconstructed_line =
                        m["other_pre"] *
                        "\"" *
                        m["string_pre"] *
                        m["folder"] *
                        "/" *
                        m["subfolder"] *
                        "/day" *
                        day_string *
                        "_input.txt\"" *
                        m["other_post"] *
                        "\n"
                    @assert line == reconstructed_line "line was not reconstructed correctly by the script parser"
                end
                source[i] =
                    m["other_pre"] *
                    "\"" *
                    m["string_pre"] *
                    m["folder"] *
                    "/" *
                    subfolder *
                    "/day" *
                    day_string *
                    "_input.txt\"" *
                    m["other_post"] *
                    "\n"
            end
        end
    end
end

function global_answer!(source::Vector{String}, f::String)
    """Add "global' before answer in the script body"""
    found = false
    for i = 0:(length(source)-1)
        if occursin(r"answer\s?=.+", source[end-i])
            source[end-i] = "global " * source[end-i]
            found = true
            break
        end
    end
    if !found
        m = match(r"[ \t]*#*[ \t]*@show\s(?'stuff'.*)", source[end])
        if (m !== nothing)
            @warn "'answer' not found in $f, but the last line starts with @show. assuming this is the answer"
            source[end] *= source[end][end] != "\n" ? "\n" : ""
            push!(source, "global answer = " * m["stuff"] * "\n")
        end
    end
end

function begin_end!(source)
    pushfirst!(source, "begin\n")
    source[end] *= source[end][end] != "\n" ? "\n" : ""
    push!(source, "\nend")
end

function comment_prints!(source)
    for i = 1:length(source)
        line = source[i]
        m = match(r"^\s*(print|println|@show|printstyled).*", line)
        if (m !== nothing)
            source[i] = "# " * line
        end
    end
end
# global answer

function eval_source(source, f)
    global answer = undef
    # This can throw Base.Meta.ParseError("unexpected \")\"") due to multiline print commenting
    # DOTO: Deal with ^
    eval(Meta.parse(join(source)))
    if answer === undef
        error("'answer' not defined in $f")
    else
        return answer
    end
end

answers = Matrix{Int64}(undef, 0, 4)
for f in readdir(root)
    m = match(r"(?>\.\/)?day(?'day'\d{2})_(?'part'[1|2])\.jl", f)
    if (m !== nothing)
        day_string = String(m["day"])
        day, part = parse(Int, m["day"]), parse(Int, m["part"])
        source = open(f, "r") do io
            return readlines(io, keep = true)
            # return read
        end
        comment_prints!(source)
        global_answer!(source, f)
        begin_end!(source)

        println("--- $f ---")
        println(" test data ...")
        switch_data_source!(source, day_string, "test")
        answer_test = eval_source(source, f)

        # println("running $f with reduced data")
        # switch_data_source!(source, day_string, "reduced")
        # answer_reduced = eval_source(source, f)

        println(" full data ...")
        switch_data_source!(source, day_string, "full")
        answer_full = eval_source(source, f)

        println("")
        row = [day, part, answer_test, answer_full]
        global answers = vcat(answers, row')
    end
end

## TODO: print markdown table
for row in eachrow(answers)
    println(row)
end
