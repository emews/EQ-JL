"""
Genetic Algorithm
Authors: Carmine Spagnuolo and Giuseppe D'Ambrosio

"""
tstartglobal=time()
using Distributed
using eqjl
using pool

# import Pkg
# Pkg.add("Random")
using Random
# Pkg.add("Distributions")
using Distributions
# Pkg.add("JSON")
using JSON

# object function executed from workers
# the string should contain the path to the folder containing the function
# and the name of the module, separated by ;
# ex: path/to/folder;moduleName
const objfunc = string(pwd(), "/julia;objfunc")

# objective function
function objfuncF(pops)
	x = pops[1]
    y = pops[2]
    sin(4 * x) + sin(4 * y) + -2 * x + x^2 - 2 * y + y^2
end

# tournament selection
function selection(pop, groupSize)
	N = length(pop)
	selection = fill(0,N)
	nFitness = length(pop)

	for i in 1:N
		# first select a random contender
		contender = unique(rand(1:nFitness, groupSize))
		while length(contender) < groupSize
			contender = unique(vcat(contender, rand(1:nFitness, groupSize - length(contender))))
		end

		# find the best
		winner = first(contender)
		winnerFitness = pop[winner]
		for idx = 2:groupSize
			c = contender[idx]
			if winnerFitness < pop[c]
				winner = c
				winnerFitness = pop[c]
			end
		end

		selection[i] = winner
	end
	return selection
end

# uniform (binomial) crossover function 
# crossover two parents to create two children
# cross_pb must be between [0,1]
function crossover(p1, p2, cross_pb)
	# children are copies of parents by default
	l = length(p1)
    c1 = copy(p1)
    c2 = copy(p2)
	j = rand(1:l)
	# check for recombination
	for i in (((1:l).+j.-2).%l).+1
		if rand() <= cross_pb
			val = p1[i]
    		p1[i] = p2[i]
    		p2[i] = val
		end
	end
	return c1, c2
end

# mutation operator
function mutation(recombinant, sigma)
	d = Distributions.Normal(0, sigma)
	recombinant .+= rand(d)
	return recombinant
end

# genetic algorithm search of the one max optimization problem
function genetic_algorithm()
	println("algorithm.jl starting genetic_algorithm()")	
	global res

    # Getting settings filename
    eqjl.OUT_put("Params")
    algo_params_file = eqjl.IN_get()

	# Reading settings from file
    params = JSON.parsefile(algo_params_file)
    Random.seed!(params["seed"])
    num_iter = params["num_iter"]
    num_pop = params["num_pop"]
	sigma = params["sigma"]
	mate_pb = params["mate_pb"]
    mutate_pb = params["mutate_pb"]
    crossover_pb = params["crossover_pb"]
	e = params["e"]
	
	tmp_dir = joinpath(ENV["TURBINE_OUTPUT"], "tmp") 

	# JLMap Pool
    global _pool = Pool(tmp_dir, "workers")
    @eval @everywhere _pool = _pool

	# Creating initial population of random Float
	individuals = ()->Float64[rand(0.0:0.01:5.0), rand(0.0:0.01:5.0)]
    pop = [individuals() for _ in (1:num_pop)]

	# Enumerate generations
	for gen in (1:num_iter)
		# Evaluate all candidates in the population using JLMap
		fitness = mapWorker(_pool, objfunc, pop)
		minFitness, fitidx = findmin(fitness)
		offspring = similar(pop)
		selected = selection(fitness, floor(Int, num_pop/2))

		# perform matingstate fitness
		offidx = Random.randperm(num_pop)
		eliteSize = isa(e, Int) ? e : round(Int, e * num_pop)
		offspringSize = num_pop - eliteSize

		for i in 1:2:offspringSize
			ij = (i == offspringSize) ? i-1 : i+1
			if rand() < crossover_pb
				offspring[i], offspring[ij] = crossover(pop[selected[offidx[i]]], pop[selected[offidx[ij]]], crossover_pb)
			else
				offspring[i], offspring[ij] = pop[selected[i]], pop[selected[ij]]
			end
		end

		fitidxs = sortperm(fitness)

		for j in 1:eliteSize
			subs = offspringSize+j
			offspring[subs] = copy(pop[fitidxs[j]])
		end

		for k in 1:offspringSize
			if rand() < mutate_pb
				mutation(offspring[k], sigma)
			end
		end
		
		for ik in 1:num_pop
			pop[ik] = offspring[ik]
		end

		fitness = mapWorker(_pool, objfunc, offspring)
		minfit, fitidx = findmin(fitness)
		best = pop[fitidx]
		best_eval = fitness[fitidx]
		res = string("f(", best, ") = ", best_eval)
	end
	tend=time()
	res = string(res, ", total elapsed: ", tend-tstartglobal)
    eqjl.OUT_put("DONE")
    println("###DONE")
    eqjl.OUT_put(res)
end

@async genetic_algorithm()