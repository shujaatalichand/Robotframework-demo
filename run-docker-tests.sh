#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

IMAGE_NAME="robotframework-demo"
RESULTS_DIR="$(pwd)/results"

docker build -t "$IMAGE_NAME" .
docker run --rm -v "$RESULTS_DIR:/robot/results" "$IMAGE_NAME" "$@"

echo ""
echo "Report: file://$RESULTS_DIR/report.html"
echo "Log:    file://$RESULTS_DIR/log.html"
