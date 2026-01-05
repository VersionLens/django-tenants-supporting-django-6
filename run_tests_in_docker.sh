#!/bin/bash

set -e

pip install -e .

echo "Starting tests..."
./run_tests.sh
