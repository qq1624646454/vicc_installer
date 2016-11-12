#!/bin/bash
#

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
source ${JLLPATH}/BashShellLibrary

#-----------------------
# The Main Entry Point
#-----------------------

##
##
## Boot_xxx/logcat.txt
## Boot_xxx/logcat.txt.1
## Boot_xxx/logcat.txt.10
## Boot_xxx/logcat.txt.2
##
## Fn_LogcatFile_SortByDigit "$(pwd)/Boot_0000" "logcat.txt."
function Fn_LogcatFile_SortByDigit()
{
    if [ $# -ne 2 ]; then
        Lfn_Sys_DbgEcho "Sorry, Return"
        return
    fi
    if [ ! -e "$1" ]; then
        Lfn_Sys_DbgEcho "Sorry, Return"
        return
    fi
    cd $1
    if [ -e "$(pwd)/temp" ]; then
        rm -f $(pwd)/temp 2>/dev/null
    fi
    mkdir -pv $(pwd)/temp
    cp -rvf $(pwd)/$2* $(pwd)/temp
    cd temp
    echo "" > merged.logcat 
    LvFsbdFiles="$(ls $2* 2>/dev/null)"
    if [ x"${LvFsbdFiles}" != x ]; then
        declare -a LvFsbdSet
        declare -a LvFsbdSet2
        LvFsbdIdx=0
        for LvFsbdEntry in ${LvFsbdFiles}; do
            LvFsbdE="${LvFsbdEntry/*./0}"
            LvFsbdSet[LvFsbdIdx]="${LvFsbdE}"
            LvFsbdSet2[LvFsbdIdx]="${LvFsbdEntry}"
            LvFsbdIdx=$(( LvFsbdIdx + 1 ))
            eval mv -f ${LvFsbdEntry} ${LvFsbdE} 
        done

        for (( LvFsbdI=0 ; LvFsbdI<LvFsbdIdx ; LvFsbdI++ )) do
            for (( LvFsbdJ=LvFsbdI+1 ; LvFsbdJ<LvFsbdIdx ; LvFsbdJ++ )) do
                if [ ${LvFsbdSet[LvFsbdI]} -gt ${LvFsbdSet[LvFsbdJ]} ]; then
                    LvFsbdT="${LvFsbdSet[LvFsbdI]}"
                    LvFsbdSet[LvFsbdI]="${LvFsbdSet[LvFsbdJ]}"
                    LvFsbdSet[LvFsbdJ]="${LvFsbdT}"
                    LvFsbdT2="${LvFsbdSet2[LvFsbdI]}"
                    LvFsbdSet2[LvFsbdI]="${LvFsbdSet2[LvFsbdJ]}"
                    LvFsbdSet2[LvFsbdJ]="${LvFsbdT2}"
                fi
            done 
        done

        for (( LvFsbdI=0 ; LvFsbdI<LvFsbdIdx ; LvFsbdI++ )) do
            echo "***** ${LvFsbdSet2[LvFsbdI]} *****" >> merged.logcat
            echo "Merge \"${LvFsbdSet2[LvFsbdI]}: ${LvFsbdSet[LvFsbdI]}\" is appended to \"merged.logcat\""
            cat  ${LvFsbdSet[LvFsbdI]} >> merged.logcat 
        done
        unset LvFsbdSet 
        unset LvFsbdSet2
    fi
    cp -rvf merged.logcat ../
    cd ../
    rm -rvf temp
    if [ -e "$(pwd)/logcat.txt" ]; then
        echo "***** logcat.txt *****" >> merged.logcat
        echo "Merge \"logcat.txt\" is appended to \"merged.logcat\""
        cat  logcat.txt >> merged.logcat 
    fi
    mv merged.logcat ../$(basename $1).merged.logcat
    cd ..
}

echo "###################################################################"
echo "# MERGING CAN TAKE SEVERAL MINUTES, PLEASE WAIT TILL IT COMPLETES #"
echo "###################################################################"
echo "    MERGING IN PROGRESS......"

GvDirList=$(ls -l | grep -E '^d' | grep -E "Boot_*" | awk -F ' ' '{print $9}')
for GvDir in ${GvDirList}; do
    Fn_LogcatFile_SortByDigit "$(pwd)/${GvDir}" "logcat.txt."
done

exit 0
####################################################################
#  Copyright (c) 2015.  lin_jie_long@126.com,  All rights reserved.
####################################################################


