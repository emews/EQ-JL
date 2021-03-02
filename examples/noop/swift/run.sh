#!/bin/sh
set -eu

# RUN
# Swift/T runner script
# Sets up paths and runs Swift/T

set -x

THIS=$( readlink --canonicalize $( dirname $0 ) )
export EMEWS_PROJECT_ROOT=$( readlink --canonicalize $THIS/.. )
EQJL=$( readlink --canonicalize $EMEWS_PROJECT_ROOT/../../src )

export JULIAPATH=$EMEWS_PROJECT_ROOT/julia:$EQJL
echo $JULIAPATH
export TURBINE_RESIDENT_WORK_WORKERS=1

stc -p -I $EQJL -r$EQJL $EMEWS_PROJECT_ROOT/swift/workflow.swift

turbine -n 3 $EMEWS_PROJECT_ROOT/swift/workflow.tic --module="algorithm"
