#!/bin/bash

# minimal security:
[ -f demo.sh ] || {
    echo "Script must be launched from its folder (./demo.sh). Exiting."
    exit 1
}

find golomb -name *.cpp -delete
find golomb -name *.c -delete

# we copy the source file to able to call them by different names
cp -f golomb/golomb.py golomb/golomb_basic.py
python setup_basic.py build_ext --inplace

# cython+ version
python setup.py build_ext --inplace


echo "----------------------------------------"
echo "Python version:"
python -m timeit "from golomb.golomb import main; main()"

echo "Minimal Cython version:"
python -m timeit "from golomb.golomb_basic import main; main()"

echo "Cython+ version:"
python -m timeit "from golomb.golomb_cyp import main; main()"
