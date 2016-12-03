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

if [ -n "$2" ] ; then
  FILTER_BOTTOM=${1//./}
  FILTER_TOP=${2//./}
else
  if [ -n "$1" ] ; then
    FILTER_TOP=${1//./}
    FILTER_BOTTOM=0
  else
    FILTER_TOP=99999
    FILTER_BOTTOM=0
  fi
fi

COMPILERS="3.07.0 3.07.1 3.07.2 3.08.0 3.08.1 3.08.2 3.08.3 3.08.4 3.09.0 3.09.1 3.09.2 3.09.3 3.10.0 3.10.1 3.10.2 3.11.0 3.11.1 3.11.2 3.12.0 3.12.1 4.00.0 4.00.1 4.01.0 4.02.0 4.02.1 4.02.2 4.02.3 4.03.0 4.04.0"
COUNT=0
for i in $COMPILERS ; do
  if [ ${i//./} -le $FILTER_TOP -a ${i//./} -ge $FILTER_BOTTOM ] ; then
    COUNT=$((COUNT+1))
  fi
done
POS=0
INCR=$((1080/COUNT))
ROWS=$((85/COUNT))
echo Started at `date`
for i in $COMPILERS ; do
  if [ ${i//./} -le $FILTER_TOP -a ${i//./} -ge $FILTER_BOTTOM ] ; then
    #mintty --size 269,$ROWS --position 0,$POS ./build.sh $i &
    if [ ${i//.} -lt 3080 ] ; then
      for j in .tar.gz -patch1.diffs -patch2.diffs ; do
        NAME=ocaml-3.07$j
        if [ ! -e $NAME ] ; then
          wget http://caml.inria.fr/pub/distrib/ocaml-3.07/$NAME
        fi
      done
    elif [ ! -e ocaml-$i.tar.gz ]; then
      wget http://caml.inria.fr/pub/distrib/ocaml-${i%.*}/ocaml-$i.tar.gz
    fi
    ./build.sh $i
    POS=$((POS+INCR))
  else
    echo $i skipped by filter
  fi
done
