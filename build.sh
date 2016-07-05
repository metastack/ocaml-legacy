#!/bin/bash
# ################################################################################################ #
# MetaStack Solutions Ltd.                                                                         #
# ################################################################################################ #
# OCaml Legacy Versions Batch Build Script                                                         #
# ################################################################################################ #
# Copyright (c) 2016 MetaStack Solutions Ltd.                                                      #
# ################################################################################################ #
# Author: David Allsopp                                                                            #
# 17-Jun-2016                                                                                      #
# ################################################################################################ #
# Redistribution and use in source and binary forms, with or without modification, are permitted   #
# provided that the following two conditions are met:                                              #
#     1. Redistributions of source code must retain the above copyright notice, this list of       #
#        conditions and the following disclaimer.                                                  #
#     2. Neither the name of MetaStack Solutions Ltd. nor the names of its contributors may be     #
#        used to endorse or promote products derived from this software without specific prior     #
#        written permission.                                                                       #
#                                                                                                  #
# This software is provided by the Copyright Holder 'as is' and any express or implied warranties  #
# including, but not limited to, the implied warranties of merchantability and fitness for a       #
# particular purpose are disclaimed. In no event shall the Copyright Holder be liable for any      #
# direct, indirect, incidental, special, exemplary, or consequential damages (including, but not   #
# limited to, procurement of substitute goods or services; loss of use, data, or profits; or       #
# business interruption) however caused and on any theory of liability, whether in contract,       #
# strict liability, or tort (including negligence or otherwise) arising in any way out of the use  #
# of this software, even if advised of the possibility of such damage.                             #
# ################################################################################################ #

if [ -z "$1" ] ; then
  echo "Specify OCaml version to build">&2
  exit 1
fi

VER=${1//.}
if [ $VER -lt 3080 ] ; then
  echo Extracting OCaml 3.07
  TDIR=t-ocaml-$1
  if [ -d $TDIR ] ; then
    rm -rf $TDIR
  fi
  mkdir $TDIR
  cd $TDIR
  tar -xzf ../ocaml-3.07.tar.gz
  REV=${1//*.}
  if [ $REV -eq 0 ] ; then
    DIR=ocaml-3.07
  else
    echo Patching to pl$REV
    cd ocaml-3.07
    patch -p1 -i ../../ocaml-3.07-patch$REV.diffs
    cd ..
    DIR=ocaml-3.07+$REV
  fi
  if [ -d ../$DIR ] ; then
    rm -rf ../$DIR
  fi
  mv ocaml-3.07 ../$DIR
  cd ..
  rmdir $TDIR
  PATCHES="ocamldoc-build config-option-3.07 cc-profile PR3485 PR4614 PR4700 PR5011 ocamldoc-3.07 mingw-to-3.08.4 msvc-to-3.08.4"
else
  DIR=ocaml-$1

  if [ -d $DIR ] ; then
    rm -rf $DIR
  fi

  echo Extracting OCaml $1
  tar -xzf $DIR.tar.gz
  if [ $VER -gt 4001 ] ; then # 4.01+
    PATCHES=tcl-tk-amd64-4.x
  elif [ $VER -gt 4000 ] ; then # 4.00.1
    PATCHES="PR5011-3.12+4.00 tcl-tk-amd64-4.x"
  elif [ $VER -gt 3121 ] ; then # 4.00.0
    PATCHES="ocamldoc-build PR5011-3.12+4.00 tcl-tk-amd64-4.x"
  elif [ $VER -gt 3112 ] ; then # 3.12.x
    PATCHES="ocamldoc-build PR5011-3.12+4.00 mingw-to-3.12.1 tcl-tk-amd64-3.11-85"
  elif [ $VER -gt 3111 ] ; then # 3.11.2
    PATCHES="ocamldoc-build PR4700 PR5011-3.11 mingw-to-3.12.1 msvc64-3.11 tcl-tk-amd64-3.11-85"
  elif [ $VER -gt 3102 ] ; then # 3.11.0 & 3.11.1
    PATCHES="ocamldoc-build PR4700 PR5011-3.11 mingw-to-3.12.1 msvc64-3.11 tcl-tk-amd64-3.11-84"
  elif [ $VER -gt 3093 ] ; then # 3.10.x
    PATCHES="ocamldoc-build cc-profile PR4614 PR4700 PR5011 mingw-to-3.10.2 msvc64-3.10 tcl-tk-amd64-3.10"
  elif [ $VER -gt 3084 ] ; then # 3.09.x
    PATCHES="ocamldoc-build cc-profile PR4614 PR4700 PR5011 mingw-to-3.09.3"
  elif [ $VER -gt 3082 ] ; then # 3.08.3 - 3.08.4
    PATCHES="ocamldoc-build config-option-3.08 cc-profile PR4614 PR4700 PR5011 mingw-to-3.08.4 msvc-to-3.08.4"
  else # 3.08.0-3.08.3
    PATCHES="ocamldoc-build config-option-3.08 cc-profile PR3485 PR4614 PR4700 PR5011 mingw-to-3.08.4 msvc-to-3.08.4"
  fi
fi

cd $DIR

for i in $PATCHES ; do
  echo Applying $i.patch
  patch -p1 -i ../$i.patch
done

cd config
mv s-nt.h s.h
mv m-nt.h m.h
echo Sources left ready
exit 0
sed -e "s/ocamlmgw/OCaml/" -e "s/8[345]/84/g" Makefile.mingw > Makefile
cd ..

mkdir -p ../log
make -f Makefile.nt world bootstrap opt opt.opt 2>&1 | tee ../log/ocaml-$1.log
if [ ${PIPESTATUS[0]} -eq 0 ] ; then
  echo "Successfully completed build of $1 in $DIR at `date`">> ../log/completion.log
else
  echo "ERROR building $1 in $DIR at `date`">> ../log/completion.log
fi

cd ..

