#!/bin/bash
SPACKPATH=$1
XSDKINSTALL="$SPACKPATH install --fake xsdk<COMPILERS> ~omega-h ~dealii"

pwd
ls
echo "HEllo xsdk"
for i in $($SPACKPATH compilers | grep @)
do
    rm -rf $i
    mkdir $i
    cd $i
    pwd
    ls
    FILENAME=xsdk-install-$i.sh
    echo "$XSDKINSTALL" >> "$FILENAME"
    case "$(uname -s)" in

    Darwin)
    	sed -i '' 's/\<COMPILERS\>/'%$i'/g' $FILENAME
    ;;

    Linux)
    	sed -i 's/<COMPILERS>/'%$i'/g' $FILENAME
    ;;
    esac
    sh $FILENAME
    cd ../
done
