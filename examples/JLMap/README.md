# GA0: Genetic Algorithm, Difficulty Zero

## Work in progress ⚠️

## Quick start instructions

```
./setup.sh
swift/run_workflow.sh 1 swift/local.cfg
```

## Overview

This runs a real GA with https://juliahub.com/docs/Evolutionary.  The objective function is simply:

_sin(4x) + sin(4y) - 2x + x² - 2y + y²_

It is expressed for the workflow as a Julia snippet in workflow.swift

## File index

### Entry points

* setup.sh: Installs the EQ-JL system into this project directory
* swift/run_workflow.sh 1 swift/local.cfg: Runs the workflow with experiment's name "1"

## Authors

- _Carmine Spagnuolo_, Università degli Studi di Salerno
- _Giuseppe D'Ambrosio_, Università degli Studi di Salerno
