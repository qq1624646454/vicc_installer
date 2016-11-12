#!/bin/bash
# Copyright(c) 2016-2100   jielong.lin   All rights reserved.
#

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
source ${JLLPATH}/BashShellLibrary


function Fn_Usage()
{
cat >&1 << EOF

[DESCRIPTION]
    Help user to learn about more usage of ${CvScriptName}
    Version: v1 - 2016-2-2 


[USAGE-DETAILS] 

    ${CvScriptName} [help]
        Offer user for that how to use this command.

    ${CvScriptName} -s=<Symbol> -f=<FileType> [-f=<FileType> ... ] [-m=<0|1>] 
        -s equal to specify a symbol, such as Variable or Function Name.
        -f equal to specify a file type for filterring, such as *.c, and it 
           support for the multilse file type options.
        -m equal to specify a mode between 0 and 1.
            0 - precise (default)
            1 - comprehensive 
     Example:
        ${CvScriptName} -s=main -f=*.c -f=*.cpp -f=*.java -f=*.s -m=0
        ${CvScriptName} -s="KeyboardInputMapper::processKey() keyCode=" -f="*.c" -f=*.cpp -f=*.java -f=*.cc -m=0

EOF
}


function Fn_App_Handle()
{
  while [ $# -ne 0 ]; do
  case $1 in
    xx)
        echo "xx"
    ;;
    yy|zz)
        echo "yy|zz"
    ;;
    *)
        FnHelp | more
        exit 0 
    ;;
  esac
  shift
  done
}

function Fn_App_Handle2()
{
for ac_arg; do
    case $ac_arg in
        --hello=*)
            echo "ac_arg: $ac_arg"
            GvHello=`echo $ac_arg | sed -e "s/--hello=//g" -e "s/,/ /g"`
            echo "value: $GvHello"
            ;;
        *)
            ;;
    esac
done
}


#-----------------------
# The Main Entry Point
#-----------------------

GvSymbol=""
GvFileList=""
GvMode=""
for ac_arg; do
    case $ac_arg in
        -s=*)
            echo "ac_arg: $ac_arg"
            GvSymbol_=$(echo $ac_arg | sed -e "s/-s=//g" -e "s/,/ /g")
            echo "value: $GvSymbol_"
            if [ -z "${GvSymbol}" -a ! -z "${GvSymbol_}" -a x"${GvSymbol_}" != x"${ac_arg}" ]; then
                GvSymbol="--Symbol=\"${GvSymbol_}\""
                echo "Options:  ${GvSymbol}"
            fi
            ;;
        -f=*)
            echo "ac_arg: $ac_arg"
            GvFile_=`echo $ac_arg | sed -e "s/-f=//g" -e "s/,/ /g"`
            echo "value: $GvFile_"
            if [ ! -z "${GvFile_}" -a x"${GvFile_}" != x"${ac_arg}" ]; then
                GvFileList="${GvFileList} --File=\"${GvFile_}\""
                echo "Options:  ${GvFileList}"
            fi
            ;;
        -m=*)
            echo "ac_arg: $ac_arg"
            GvMode_=`echo $ac_arg | sed -e "s/-m=//g" -e "s/,/ /g"`
            echo "value: $GvMode_"
            if [ -z "${GvMode}" -a ! -z "${GvMode_}" -a x"${GvMode_}" != x"${ac_arg}" ]; then
                if [ x"${GvMode_}" = x"0" -o  x"${GvMode_}" = x"1" ]; then
                    GvMode="--Mode=${GvMode_}"
                    echo "Options:  ${GvMode}"
                fi
            fi
            ;;
 
        *)
            ;;
    esac
done

if [ x"${GvSymbol}" != x -a x"${GvFileList}" != x ]; then
    if [ x"${GvMode}" = x ]; then
        GvMode="--Mode=0"
        echo "Options(default):  ${GvMode}"
    fi
cat >&1 <<EOF

    Lfn_File_SearchSymbol ${GvSymbol} ${GvFileList} ${GvMode}

EOF

    eval Lfn_File_SearchSymbol ${GvSymbol} ${GvFileList} ${GvMode}
else
    Fn_Usage
fi


exit 0
####################################################################
#  Copyright (c) 2015.  lin_jie_long@126.com,  All rights reserved.
####################################################################


