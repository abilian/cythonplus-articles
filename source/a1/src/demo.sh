#!/bin/bash

# minimahsecurity:
[ -f demo.sh ] || {
    echo "Script must be launched from its folder (./demo.sh). Exiting."
    exit 1
}

find helloworld -name *.cpp -delete

python setup.py build_ext --inplace
python -c "from helloworld.helloworld import main; main()"
