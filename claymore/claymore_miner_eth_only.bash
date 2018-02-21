#!/bin/bash

# libcurl is needed (issue #203)
export LD_PRELOAD="libcurl.so.3"
# rewards info
wallet_addr="0x9875b0355cd9777f1bbd7c4ff987fbe666426210"
worker_id="mark-haus-jord"
email_addr="marcusfg@gmail.com"
pool_address="eth-us-east1.nanopool.org:9999"

# time period between http requests for new job
eth_job_req_time="500"

# timeout for failover server switch
# used to determine how long to wait before switching servers
pool_failover_timeout="-ftime 20"

# allocation (might be for AMD only)
gpu_alloc_percent=100
gpu_max_alloc_percent=100
gpu_max_heap_size=100

# intensity from 0 ~ 8 (lowest ~ highest)
mining_intensity=$#  # use this to test number of args passed
if [[ $mining_intensity == "1" ]]; then mining_intensity="$1";
elif [[ $mining_intensity == "0" ]]; then mining_intensity="default";
else
  echo "[ERROR]: Invalid number of arguments!"
  echo "Please only use one argument for intensity [0(low) - 8(high)]"
  exit 1
fi
intensity_option=""

# configure settings based on input
case $mining_intensity in
  "0" | "1" | "2")
    echo "Mining at Low intensity"
    gpu_max_heap_size="50"
    gpu_max_alloc_percent="50"
    gpu_alloc_percent="50"
  ;;
  "3" | "4" | "5")
    echo "Mining at Medium Intensity"
    gpu_max_heap_size="80"
    gpu_max_alloc_percent="80"
    gpu_alloc_percent="80"
  ;;
  "6" | "7" | "8")
    echo "Mining at High Intensity"
  ;;
  "default")
    echo "Mining with Default Settings"
    mining_intensity="8"
  ;;
 esac;

# GPU global vars (I think it only matters for AMD)
export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=$gpu_max_heap_size
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=$gpu_max_alloc_percent
export GPU_SINGLE_ALLOC_PERCENT=$gpu_alloc_percent

./ethdcrminer64 \
  -epool $pool_address \
  -ewal $wallet_addr/$worker_id/$email_addr \
  -epsw x -ethi "$mining_intensity" -etht "$eth_job_req_time" \
  -mode 1 -colors 1
