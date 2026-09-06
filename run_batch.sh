#!/bin/bash

find util/job_launching/logfiles -type f -delete
find util/job_launching/procman -type f  ! -name "*.py" -delete

GPUS=("A100" "H100" "H200" "RTX2060")

for GPU in "${GPUS[@]}"
do
    ./get_results.sh -g $GPU

    if [ $? -ne 0 ]; then
        echo "Simulation failed for $GPU"
        exit 1
    fi

    echo "Completed $GPU"
done