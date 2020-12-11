module eqjl
import Pkg;
Pkg.add("DataStructures");
using DataStructures;

    EQJL_ABORT = "EQJL_ABORT"

    input_q = Deque{Any}()
    output_q = Deque{Any}()

    function OUT_put(string_params)
        @async push!(output_q, string_params)
    end

    function IN_get()
        #here must be blocking
        while isempty(input_q)
            yield()
        end
        pop!(input_q)
    end

    function output_get()
        while isempty(output_q)
            yield()
        end
        pop!(output_q)
    end

end