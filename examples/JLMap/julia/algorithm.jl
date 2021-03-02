"""
GA0 Genetic Algorithm with 0 difficulty
Authors: Carmine Spagnuolo and Giuseppe D'Ambrosio

"""

using Distributed

# import Pkg
# Pkg.add("JSON")
import JSON
# Pkg.add("Evolutionary")
import Evolutionary
# Pkg.add("Random")
import Random
# Pkg.add("Distributions")
import Distributions

using eqjl
using pool

# object function executed from workers
# the string should contain the path to the folder containing the function
# and the name of the module, separated by ;
# ex: path/to/folder;moduleName
const objfunc = string(pwd(), "/julia;objfunc")

# fake function, computation is delegated to worker
function mapF(pops)
    # sending data that looks like 
    # [[a,b,c,d],[e,f,g,h],...]
    args = []
    push!(args, pops[1:2])
    obj_vals = mapWorker(_pool, objfunc, args)
    obj_vals[1]
end

function custom_mutate(sigma::Float64)
    function mutation(recombinant::T) where {T<:Array}
        d = Distributions.Normal(0, sigma)
        println("Mutate: ", recombinant)
        recombinant .+= rand(d)
        println("to: ", recombinant)
        return recombinant
    end
    return mutation
end

#=
:param num_iter: number of generations
:param num_pop: size of population
:param seed: random seed
=#

function main() 
    # Reading settings from file
    eqjl.OUT_put("Params")
    algo_params_file = eqjl.IN_get()
    params = JSON.parsefile(algo_params_file)

    # tmp_dir = joinpath(TURBINE_OUTPUT, "tmp") #TOCHECK HOW TO GET TURBINE_OUTPUT
    tmp_dir = "/home/giuseppe/Git/EQ-JL/examples/JLMap/experiments/1/tmp"
    
    global _pool = Pool(tmp_dir, "workers")
    @eval @everywhere _pool = _pool
    
    Random.seed!(params["seed"])
    sigma = params["sigma"]
    num_iter = params["num_iter"]
    num_pop = params["num_pop"]
    mate_pb = params["mate_pb"]
    mutate_pb = params["mutate_pb"]
    crossover_pb = params["crossover_pb"]
    
    # Creating population
    individuals = ()->Float64[rand(0.0:0.01:5.0), rand(0.0:0.01:5.0)]

    # Setting the GA algorithm
    algorithm = Evolutionary.GA(
        selection = Evolutionary.tournament(floor(Int, num_pop/2)),
        mutation =  custom_mutate(sigma),
        crossover = Evolutionary.uniformbin(mate_pb),
        mutationRate = mutate_pb,
        crossoverRate = 0.5,
        populationSize = num_pop,
        ε = 0.02
    )
    
    # Set "show_trace=false, store_trace=false" true to got more details
    opts = Evolutionary.Options(iterations=num_iter, show_every=1, show_trace=false, store_trace=false)

    println("Calling optimize")
    res = Evolutionary.optimize(mapF, individuals, algorithm, opts)

    eqjl.OUT_put("DONE")
    println("###DONE")
    eqjl.OUT_put(res)
    # println(res)
end
@async main()