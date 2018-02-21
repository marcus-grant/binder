export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100

./ethdcrminer64 -epool etc-eu1.nanopool.org:19999 -ewal YOUR_WALLET/YOUR_WORKER/YOUR_EMAIL -epsw x -dpool stratum+tcp://sia-eu1.nanopool.org:7777 -dwal YOUR_SIA_WALLET/YOUR_WORKER/YOUR_EMAIL -dpsw x -dcoin sia -etht 1000 -dcrt 1000 -ftime 1 -allpools 1