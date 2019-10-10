#!/bin/bash
# First parameter must be the spack binary full path
# Second parameter is optionnal and have to be a list of compilers

SPACKEXEPATH=$1
XSDKINSTALL="$SPACKEXEPATH install --keep-stage --source xsdk<COMPILERS>"

COMPILERS=( $2 )
if [ -z "$COMPILERS" ]; then
   COMPILERS=$($SPACKEXEPATH compilers | grep @)
else
   COMPILERS="${COMPILERS[@]}"
fi
echo "Tests of xsdk installation with the compilers : $COMPILERS"
for i in $COMPILERS
do
    rm -rf $i
    mkdir $i
    cd $i
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
