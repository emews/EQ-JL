module objfunc #NECESSARY module name matching filename without.jl
export objfuncF #NECESSARY the function that the worker will call
function objfuncF(x,y)
    sin(4 * x) + sin(4 * y) + -2 * x + x^2 - 2 * y + y^2
end

end