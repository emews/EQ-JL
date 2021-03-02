import Pkg;
Pkg.add("JLD");
using JLD;

function chunker(li, total_chunks)
    item_count = length(li)
    if total_chunks > item_count
        num_chunks = item_count
    else
        num_chunks = total_chunks
    end
    chunk_size = round(Int, item_count / num_chunks, RoundDown)
    remainder = item_count - (chunk_size * num_chunks)
    used_chunk_size = chunk_size + 1
    r = []
    for i  = 0:num_chunks-1
        if i >= remainder
            cs = used_chunk_size - 1
        else
            cs = used_chunk_size
        end

        if i >= remainder
            offset = remainder
        else
            offset = 0
        end
        start = (i * cs + offset) + 1
        _end = (i * cs + offset) + cs
        push!(r, li[start:_end])
    end
    return r
end

function run(chunk_idx, total_chunks, step, data_dir)
    
    args_path = string("args_", step, ".jld")
    args_f = joinpath(data_dir, args_path)
    args = jldopen(args_f, "r") do f_in
        read(f_in, "data")
    end
    
    # the file should contain the path to the folder containing the function
    # and the name of the module, separated by ;
    # ex: path/to/folder;moduleName
    func_path = string("func_", step, ".jld")
    func_f = joinpath(data_dir, func_path)
    func = jldopen(func_f, "r") do f_in
        read(f_in, "data")
    end

    global functionPath = split(func, ";")[1]
    moduleName = split(func, ";")[2]

    # function import
    # all worker has the path in workspace need using Distributed
    push!(LOAD_PATH, functionPath) #path to the folder containing the objfunc
    _module = Symbol(moduleName) #module name
    @eval using $_module

    if total_chunks == 1
        chunk = args
    else
        chunk = chunker(args, total_chunks)[chunk_idx]
    end

    result = []
    
    for arg in chunk
        _func(args; kws...) = @eval objfuncF($args...; $kws...)
        push!(result, _func(arg))
    end

    result_path = string("result_", chunk_idx, ".jld")
    result_f = joinpath(data_dir, result_path)
    jldopen(result_f, "w") do f_out
        write(f_out, "data", result)
    end    
end

if abspath(PROGRAM_FILE) == @__FILE__
    chunk_idx = parse(Int, ARGS[1])
    total_chunks = parse(Int, ARGS[2])
    step = parse(Int, ARGS[3])
    data_dir = ARGS[4]
    println("worker.jl starting with chunk_idx: ", chunk_idx, "| total_chunks: ",total_chunks, " | step: ", step, " | data_dir: ", data_dir)
    run(chunk_idx, total_chunks, step, data_dir)
end