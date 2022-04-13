#!/bin/bash

# minimal security:
[ -f demo.sh ] || {
    echo "Script must be launched from its folder (./demo.sh). Exiting."
    exit 1
}

find utils -name *.cpp -delete
find utils -name *.c -delete

python setup.py build_ext --inplace

echo "----------------------------------------"
python -c "from utils.demo_utils import main; main()"
