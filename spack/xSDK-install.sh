#!/bin/bash
SPACKEXEPATH=$1
XSDKINSTALL="$SPACKEXEPATH install --keep-stage --source xsdk<COMPILERS>"

echo "Tests of xsdk installation"
for i in $($SPACKEXEPATH compilers | grep @)
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
