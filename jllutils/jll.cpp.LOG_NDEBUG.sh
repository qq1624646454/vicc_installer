#!/bin/bash
# Copyright (c) 2016-2100,  jielong_lin,  All rights reserved.
#
JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
#source ${JLLPATH}/BashShellLibrary

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"

GvCurrentPath=$(pwd)
GvCppFiles=$(find ${GvCurrentPath} -type f -a -name \*.cpp)
for GvCppF in ${GvCppFiles}; do
    echo -e "\r\n\033[0m\033[31m\033[43m${GvCppF##${GvCurrentPath}/}\033[0m:LOG_NDEBUG=0\r\n"
    sed "s://#define LOG_NDEBUG 0:#define LOG_NDEBUG 0:g" -i ${GvCppF} 
done

git status -s

