"""
EMEWS simple noop example using Julia code.
Please refer to the Python example, for more details:
https://github.com/emews/EQ-Py/tree/master/examples/noop
Authors: Carmine Spagnuolo and Giuseppe D'Ambrosio

"""

include("../ext/EQ-JL/eqjl.jl")
using .eqjl
function algo() 
    eqjl.OUT_put("1;2;3;4;5;6")
    result = eqjl.IN_get()
    eqjl.OUT_put("33;45;46")
    result = eqjl.IN_get()
    eqjl.OUT_put("FINAL")
end
@async algo()
