#!/bin/bash

# minimal security:
[ -f demo.sh ] || {
    echo "Script must be launched from its folder (./demo.sh). Exiting."
    exit 1
}

find cypxml -name *.cpp -delete

python setup.py build_ext --inplace

python -c "from cypxml.test_cypxml import main; main()"
echo
echo "------------- cypxml/demo_cypxml.pyx :"
cat cypxml/demo_cypxml.pyx
echo "--------------------------------------"
echo
python -c "from cypxml.demo_cypxml import main; main()"
