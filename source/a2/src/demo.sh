#!/bin/bash

# minimal security:
[ -f demo.sh ] || {
    echo "Script must be launched from its folder (./demo.sh). Exiting."
    exit 1
}

find containers -name *.cpp -delete

python setup.py build_ext --inplace
python -c "from containers.containers_v1 import main; main()"
python -c "from containers.containers_v2 import main; main()"
python -c "from containers.list_sort_reverse_in_place import main; main()"
