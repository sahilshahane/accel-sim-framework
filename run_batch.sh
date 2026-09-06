#!/bin/bash

find util/job_launching/logfiles -type f -delete
find util/job_launching/procman -type f  ! -name "*.py" -delete

GPUS=("A100" "H100" "H200" "RTX2060")

TRACES_DIR="./hw_run_teslav100/rodinia_2.0-ft/11.0"

for GPU in "${GPUS[@]}"
do
    ./get_results.sh -g $GPU -d $TRACES_DIR

    if [ $? -ne 0 ]; then
        echo "Simulation failed for $GPU"
        exit 1
    fi

    echo "Completed $GPU"
done