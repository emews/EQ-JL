module eqjl
export OUT_put, IN_get, output_get, input_q, output_q

using DataStructures

    EQJL_ABORT = "EQJL_ABORT"

    global input_q = Deque{Any}()
    global output_q = Deque{Any}()

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