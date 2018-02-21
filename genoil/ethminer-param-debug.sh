#!/bin/bash

# Benchmark parameters
BENCH_WARMUP_TIME=5 #seconds
BENCH_TRIAL_TIME=5 # individual trial time
BENCH_TRIAL_COUNT=5 # number of trials to run

# Pool URL, in this case nanopool's US East server
POOL_URL="eth-us-east1.nanopool.org:9999"
WALLET_ADDR="0x9875b0355cd9777f1bbd7c4ff987fbe666426210"
EMAIL="marcusfg@gmail.com"
WORKER_NAME="mark-haus-jord"
# The ID for which stratum will mark mining jobs
# requires the wallet address that this will deposit to
# requires an arbitrary worker name which can be used in nanopool to ID machine
# email or any other unique name to tie all workers together under one name
STRATUM_CRED="$WALLET_ADDR.$WORKER_NAME/$EMAIL"

# parameters for full-speed performance profile $1 = 4
FULL_GRID_SIZE="8192"
FULL_BLOCK_SIZE="256"
FULL_ENABLE_SYNC_OBJECT=1
FULL_GPU_ALLOC_PERC=100
FULL_GPU_SINGLE_ALLOC_PERC=100

# parameters for default performance profile $1 = 3 or $1 = N/A
DEFAULT_GRID_SIZE="4096"
DEFAULT_BLOCK_SIZE="128"
DEFAULT_HEAP_SIZE_PERC=90
DEFAULT_ENABLE_SYNC_OBJECT=1
DEFAULT_GPU_ALLOC_PERC=90
DEFAULT_GPU_SINGLE_ALLOC_PERC=90

# parameters for practical-speed performance profile $1 = 2
# ie for normal in-person usage of the host system
PRACTICAL_GRID_SIZE="1024"
PRACTICAL_BLOCK_SIZE="128"
PRACTICAL_HEAP_SIZE_PERC=80
PRACTICAL_ENABLE_SYNC_OBJECT=1
PRACTICAL_GPU_ALLOC_PERC=80
PRACTICAL_GPU_SINGLE_ALLOC_PERC=80

# parameters for low-speed performance profile $1 = 1
# use when decent need of GPU is expected when working on host system
LOW_GRID_SIZE="96"
LOW_BLOCK_SIZE="8"
LOW_HEAP_SIZE_PERC=50
LOW_ENABLE_SYNC_OBJECT=1
LOW_GPU_ALLOC_PERC=50
LOW_GPU_SINGLE_ALLOC_PERC=50

# performance parameters based on $1
if [[ "$1" == "1" ]]; then
  echo "Using the lowest performance level to mine ethereum!"
  SELECTED_GRID_SIZE=$LOW_GRID_SIZE
  SELECTED_BLOCK_SIZE=$LOW_BLOCK_SIZE
  SELECTED_HEAP_SIZE_PERC=$LOW_HEAP_SIZE_PERC
  SELECTED_GPU_MAX_ALLOC_PERC=$LOW_GPU_ALLOC_PERC
  SELECTED_GPU_SINGLE_ALLOC_PERC=$LOW_GPU_SINGLE_ALLOC_PERC
  SELECTED_ENABLE_SYNC_OBJECT=$DEFAULT_ENABLE_SYNC_OBJECT
elif [[ "$1" == "2" ]]; then
  echo "Using a practical performance level to mine ethereum!"
  SELECTED_GRID_SIZE=$PRACTICAL_GRID_SIZE
  SELECTED_BLOCK_SIZE=$PRACTICAL_BLOCK_SIZE
  SELECTED_HEAP_SIZE_PERC=$PRACTICAL_HEAP_SIZE_PERC
  SELECTED_GPU_MAX_ALLOC_PERC=$PRACTICAL_GPU_ALLOC_PERC
  SELECTED_GPU_SINGLE_ALLOC_PERC=$PRACTICAL_GPU_SINGLE_ALLOC_PERC
  SELECTED_ENABLE_SYNC_OBJECT=$DEFAULT_ENABLE_SYNC_OBJECT
elif [[ "$1" == "4" ]]; then
  echo "Using the full-tilt performance level to mine ethereum!"
  CUDA_GRID_SIZE=$FULL_GRID_SIZE
  CUDA_BLOCK_SIZE=$FULL_BLOCK_SIZE
  SELECTED_HEAP_SIZE_PERC=$FULL_HEAP_SIZE_PERC
  SELECTED_GPU_MAX_ALLOC_PERC=$FULL_GPU_ALLOC_PERC
  SELECTED_GPU_SINGLE_ALLOC_PERC=$FULL_GPU_SINGLE_ALLOC_PERC
  SELECTED_ENABLE_SYNC_OBJECT=$DEFAULT_ENABLE_SYNC_OBJECT
else
  echo "Using default performance level to mine ethereum!"
  SELECTED_GRID_SIZE=$DEFAULT_GRID_SIZE
  SELECTED_BLOCK_SIZE=$DEFAULT_BLOCK_SIZE
  SELECTED_HEAP_SIZE_PERC=$DEFAULT_HEAP_SIZE_PERC
  SELECTED_ENABLE_SYNC_OBJECT=$DEFAULT_ENABLE_SYNC_OBJECT
  SELECTED_GPU_MAX_ALLOC_PERC=$DEFAULT_GPU_ALLOC_PERC
  SELECTED_GPU_SINGLE_ALLOC_PERC=$DEFAULT_GPU_SINGLE_ALLOC_PERC
  SELECTED_ENABLE_SYNC_OBJECT=$DEFAULT_ENABLE_SYNC_OBJECT
fi

# export performance parameters
export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=$SELECTED_HEAP_SIZE_PERC
export GPU_USE_SYNC_OBJECTS=$SELECTED_ENABLE_SYNC_OBJECT
export GPU_MAX_ALLOC_PERCENT=$SELECTED_GPU_MAX_ALLOC_PERC
export GPU_SINGLE_ALLOC_PERCENT=$SELECTED_GPU_SINGLE_ALLOC_PERC


# format options for command line statement
GRID_OPT="--cuda-grid-size $SELECTED_GRID_SIZE"
BLOCK_OPT="--cuda-block-size $SELECTED_BLOCK_SIZE"
PERF_OPTS="$GRID_OPT $BLOCK_OPT"

# apply all params into a single command line statement
# ethminer -U -S $POOL_URL -O $STRATUM_CRED $PERF_OPTS
# command line statement changed for benchmarks
ethminer -U --benchmark --benchmark-warmup $BENCH_WARMUP_TIME --benchmark-trial $BENCH_TRIAL_TIME --benchmark-trials $BENCH_TRIAL_TIME
