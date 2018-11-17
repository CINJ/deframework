#!/bin/bash
echo
echo "---------------------------------"
echo "DEFAME DEMO FRAMEWORK BUILD SCRIPT"
echo "---------------------------------"
echo ""

#CLEAN
rm -rf output
mkdir output
rm *.sym
rm src/*.sym



#FRAMEWORK CONFIGURATION
KRILL_INSTALL=8000
KRILL_RESIDENT=2000
KRILL_ZP=c0
TARGETS="test1,test2"
FILENAME="demo"

#
# SETUP OUTPUT
#
echo "...setup output..."
rm -rf output
mkdir output
cp ./data/empty.d64 ./output/output.d64

#
# MAKE PACKERS
#
echo "...make packers..."
cd loader/loader/tools/exomizer-3/src/
make
cp exomizer ../../../../../output/
cd ../../../../../

cd loader/loader/tools/bitnax-07a8c67/
gcc lz.c
cp a.out ../../../../output/bitnax
cd ../../../../


#
# MAKE KRILL LOADER PARTS
#
echo "...make Krill loader parts..."
#copy config file to the build dir for krill
cp config/config.inc loader/loader/include/

#build krill
cd loader/loader/src
#
# "Usage: $(MAKE) prg INSTALL=<install hexaddress> RESIDENT=<resident hexaddress> ZP=<zp hexaddress>"
make clean
make prg INSTALL=$KRILL_INSTALL RESIDENT=$KRILL_RESIDENT ZP=$KRILL_ZP 
cd ../../../
cp loader/loader/build/loader-c64.prg ./output
cp loader/loader/build/install-c64.prg ./output
# converts to .asm file for kick assembler
sed -e "s/config_/.const config_/" -e "s/; /\/\/ /" \
-e "s/loader_zp/.const loader_zp/"  \
-e "s/loadaddr/.const loadaddr/"  \
-e "s/decdest/.const decdest/"  \
-e "s/loadraw/.const loadraw/"  \
-e "s/loadcomp/.const loadcomp/"  \
-e "s/openfile/.const openfile/"  \
-e "s/pollblock/.const pollblock/"  \
-e "s/decrunch/.const decrunch/"  \
-e "s/drivecode/.const drivecode/"  \
-e "s/install/.const install/"  \
loader/loader/build/loadersymbols-c64.inc >output/loadersymbols.s

#
# MAKE FRAMEWORK
#
echo "...make framework..."
kick framework.s
mv framework.prg ./output
cd output
./exomizer sfx basic framework.prg 
c1541 -attach output.d64 8 -write a.out $FILENAME
cd ..


#
# MAKE DEMO PARTS
#
echo "...make demoparts..."
PART=1
IFS=',' read -r -a array <<< "$TARGETS"
for element in "${array[@]}"
do
    cd src
    kick "$element.s"
    mv "$element.prg" ../output
    cd ../output
    ./bitnax "$element.prg"
    c1541 -attach output.d64 8 -write "$element.prg.lz" 0$PART
    let PART+=1
    cd ..
done

echo "...done..."
