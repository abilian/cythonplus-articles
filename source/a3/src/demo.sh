#!/bin/bash

# minimal security:
[ -f demo.sh ] || {
    echo "Script must be launched from its folder (./demo.sh). Exiting."
    exit 1
}

find fibonacci -name *.cpp -delete

python setup.py build_ext --inplace

echo "----------------------------------------"
echo "Python version:"
python -c "from fibonacci.fibonacci import main; main()"
echo "Cython+ version:"
python -c "from fibonacci.fibonacci_cyp import main; main()"
