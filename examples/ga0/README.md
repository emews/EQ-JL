# GA0: Genetic Algorithm, Difficulty Zero

## Quick start instructions

```
./setup.sh
swift/run
```

## Overview

This runs a real EA with http://deap.readthedocs.io/en/master[DEAP].  The objective function is simply:

_sin(4x) + sin(4y) - 2x + x² - 2y + y²_

It is expressed for the workflow as a Julia snippet in workflow.swift

## File index

### Entry points

* setup.sh: Installs the EQ-JL system into this project directory
* swift/run: Runs the workflow

### Supporting files

* julia/algorithm.jl: EQ-JL program that runs the GA algorithm using Evolutionary.jl lib
* swift/settings.json: Settings processed by algorithm.jl
* swift/workflow.swift: The Swift script. Receives parameters from algorithm.jl, executes them on the objective function (`task()`), and returns results to GA.

The working of the queue is equal to the [EQ-Py queue](https://github.com/emews/EQ-Py), please refer to it.

## Authors

- _Carmine Spagnuolo_, Università degli Studi di Salerno
- _Giuseppe D'Ambrosio_, Università degli Studi di Salerno
