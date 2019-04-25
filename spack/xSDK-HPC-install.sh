#!/bin/bash

XSDKINSTALL="#!/bin/bash
#SBATCH --job-name=XSDK_TEST
#SBATCH --output=XSDK_TEST_1.out
#SBATCH --error=XSDK_TEST_1.err
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=28
#SBATCH --time=24:00:00

# Always Use node count = 1. Each node has 28 cores. You can add some Spack option to exploit the resource.
# You can put any bash script or any python programs below
spack install xsdk<COMPILERS>"

for i in $(./spack/bin/spack compilers | grep @)
do
    rm -rf $i
    mkdir $i
    cd $i
    FILENAME=xsdk-install-$i.sh
    echo "$XSDKINSTALL" >> "$FILENAME"
    sed -i '' 's/\<COMPILERS\>/'%$i'/g' $FILENAME
    sh $FILENAME
    cd ../
done
