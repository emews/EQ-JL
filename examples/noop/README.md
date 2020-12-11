# EMEWS EQJL noop example

## Usage instructions

1. Do `./setup.sh`
2. Do `bash swift/run.sh`

In this case, the ```julia/algorithm.jl``` simply sends a list of data (separated by _;_) over the queues to Swift, which increments and reports it.

## Project structure

For using the EQJL queue you must define your Julia code using the following structure:

```julia
include("../ext/EQ-JL/eqjl.jl")
using .eqjl
function algo() 
    # <<Here your code>>
end
@async algo()
```

The working of the queue is equal to the [EQPy queue](https://github.com/emews/EQ-Py), please refer to it.

### Authors

- _Carmine Spagnuolo_, Università degli Studi di Salerno
- _Giuseppe D'Ambrosio_, Università degli Studi di Salerno
