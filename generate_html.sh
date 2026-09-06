#!/bin/bash

CSV_FILES_DIR="/media/sahil/newvolume/accel-sim-framework/stats"
OUTPUT_DIR="/media/sahil/newvolume/accel-sim-framework/run_results/TESLAV100"

for csv_file in "$CSV_FILES_DIR"/stats_*.csv; do
    # Skip if no files match
    [ -e "$csv_file" ] || continue

    # Extract GPU_CONFIG from filename
    filename=$(basename "$csv_file")
    GPU_CONFIG="${filename#stats_}"
    GPU_CONFIG="${GPU_CONFIG%.csv}"

    echo "Processing: $GPU_CONFIG"

    # Create output directory
    mkdir -p "$OUTPUT_DIR/$GPU_CONFIG"

    # Generate plots
    ./util/plotting/plot-get-stats.py \
        -c "$csv_file" \
        -p "$OUTPUT_DIR/$GPU_CONFIG"
done