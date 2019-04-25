#!/bin/bash
SPACKPATH=$1
XSDKINSTALL="$SPACKPATH graph xsdk<COMPILERS>"

for i in $($SPACKPATH compilers | grep @)
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
