#!/bin/bash

set -e

rm -rf sim_run_12.8
pkill -f accel-sim.ou || echo "no existing accel-sim.ou process found"

GPU="H100"
TRACES_DIR="./hw_run_gtx1650/traces/device-0/12.8"
BENCHMARK="rodinia_2.0-ft"

usage() {
    echo "Usage: $0 [-g GPU] [-d TRACE_DIR] [-b BENCHMARK]"
    echo
    echo "Options:"
    echo "  -g    GPU config (default: H100)"
    echo "  -d    Trace directory"
    echo "        (default: ./hw_run_gtx1650/traces/device-0/12.8)"
    echo "  -b    Benchmark suite (default: rodinia_2.0-ft)"
    echo "  -h    Show help"
}

while getopts "g:d:b:h" opt; do
    case $opt in
        g)
            GPU="$OPTARG"
            ;;
        d)
            TRACES_DIR="$OPTARG"
            ;;
        b)
            BENCHMARK="$OPTARG"
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

TEST_NAME="${GPU}_test"

echo "Configuration:"
echo "  GPU        : $GPU"
echo "  Test Name  : $TEST_NAME"
echo "  Benchmark  : $BENCHMARK"
echo "  Traces     : $TRACES_DIR"

mkdir -p stats

./util/job_launching/run_simulations.py \
    -B "$BENCHMARK" \
    -C "$GPU" \
    -T "$TRACES_DIR" \
    -N "$TEST_NAME"

./util/job_launching/monitor_func_test.py \
    -v \
    -N "$TEST_NAME"

./util/job_launching/get_stats.py \
    -N "$TEST_NAME" | tee "stats/stats_${GPU}.csv"

mkdir -p sim_run

# Rename simulation output directory
if [ -d "sim_run_12.8" ]; then
    mv "sim_run_12.8" "sim_run/sim_run_12.8_${GPU}"
    echo "Moved sim_run_12.8 -> sim_run/sim_run_12.8_${GPU}"
else
    echo "Warning: sim_run_12.8 directory not found"
fi

pkill -f accel-sim.ou || echo "no existing accel-sim.ou process found"