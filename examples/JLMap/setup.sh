#!/bin/sh
set -eu

THIS=$( dirname $0 )
$THIS/../../src/install $THIS/ext/EQ-JL

chmod +x $THIS/ext/EQ-JL/run_worker.sh