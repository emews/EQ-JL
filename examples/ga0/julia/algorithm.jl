"""
GA0 Genetic Algorithm with 0 difficulty
Authors: Carmine Spagnuolo and Giuseppe D'Ambrosio

"""

using eqjl

import Pkg
Pkg.add("JSON")
import JSON
Pkg.add("Evolutionary")
import Evolutionary
Pkg.add("Random")
import Random
Pkg.add("Distributions")
import Distributions

function map(pops)
    eqjl.OUT_put(join(pops, ","))
    result = eqjl.IN_get()
    parse(Float64, result)
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
:param csv_file_name: csv file name (e.g., "params_for_deap.csv")
=#

function main() 
    # Reading settings from file
    eqjl.OUT_put("Settings")
    settings_filename = eqjl.IN_get()
    settings = JSON.parsefile(settings_filename)

    Random.seed!(settings["seed"])
    sigma = settings["sigma"]
    num_iter = settings["num_iter"]
    num_pop = settings["num_pop"]
    mate_pb = settings["mate_pb"]
    mutate_pb = settings["mutate_pb"]
    crossover_pb = settings["crossover_pb"]

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

    res = Evolutionary.optimize(map, individuals, algorithm, opts)
    
    eqjl.OUT_put("FINAL")
    println("###FINAL sended")
    eqjl.OUT_put(res)
    # println(res)
end
@async main()
