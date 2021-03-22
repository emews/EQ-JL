set -eu

# chunk_idx, total_chunks, step, data_dir
CHUNK_IDX=$1
TOTAL_CHUNKS=$2
STEP=$3
DATA_DIR=$4

EQJL_ROOT=$( cd $( dirname $0 ) ; /bin/pwd )
# site specific file, set via export
if [[ ${SITE_FILE:-} != "" ]]
then
    source $SITE_FILE
fi

echo "Running jlmap worker"
# using sysimage to reduce execution time
julia --sysimage $EQJL_ROOT/emews/worker.so $EQJL_ROOT/emews/worker.jl $CHUNK_IDX $TOTAL_CHUNKS $STEP $DATA_DIR