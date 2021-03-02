module pool
export Pool, mapWorker
import Pkg
Pkg.add("JLD")
using JLD

using eqjl

    mutable struct Pool
        tmp_dir::String
        rank_type::String
        clean_tmp::Bool
        step::Int64
        function Pool(tmp_dir, rank_type)
            if !(rank_type in ["workers", "leaders"])
                error("rank_type must be one of 'workers' or 'leaders'")
            end
            
            if !(ispath(tmp_dir))
                mkdir(tmp_dir)
            end

            new(tmp_dir, rank_type, false, 1)
        end
    end
    
    function __read_result(pool, fname)
        # println("pool.jl __read_result fname: ", fname)
        r = jldopen(fname, "r") do f_in
            read(f_in, "data")
        end
        return r
    end

    function mapWorker(pool, func, args)

        func_path = string("func_", pool.step, ".jld")
        func_f = joinpath(pool.tmp_dir, func_path)
        jldopen(func_f, "w") do f_out
            write(f_out, "data", func)
        end

        args_path = string("args_", pool.step, ".jld")
        args_f = joinpath(pool.tmp_dir, args_path)
        jldopen(args_f, "w") do f_out
            write(f_out, "data", args)
        end

        cmd = string("jlmap|", pool.step, "|", length(args), "|", pool.tmp_dir, "|", pool.rank_type)
        OUT_put(cmd)
        
        result = IN_get()
        pool.step += 1
        results = split(result, ";")
        
        lists = [__read_result(pool, x) for x in results]
        return [y for x in lists for y in x]
    end
    
end