#!/bin/bash
# Copyright(c) 2016-2100.  jll.  All rights reserved.
#
#   FileName:     jll.sync_jllutils.sh
#   Author:       jll
#   Email:        493164984@qq.com
#   DateTime:     2017-04-19 11:56:28
#   ModifiedTime: 2017-04-19 12:02:58

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
#source ${JLLPATH}/BashShellLibrary

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"

declare -a __arrList=(
       BashShellLibrary
       jll.LogcatMerge.forTPV.sh
       jll.PhilipsTV.msaf.mtk.sh
       vicc.preview.API.sh
       jll.cpp.LOG_NDEBUG.sh
       jll.patchs_for_merge.sh
       jll.sshconf.sh
       jll.GIT.sh
       jll.PhilipsTV.2k16.asta.mtk.sh
       jll.symbol.sh
       jll.git.sync.sh
       jll.PhilipsTV.2k17.asta.mtk.sh
       vicc.insight.change.sh
)

__arrCnt=${#__arrList[@]}
for((i=0; i<__arrCnt; i++)) {
    if [ -e "/home/jll/Vanquisher/jllutils/${__arrList[i]}" ]; then
        cp -rvf /home/jll/Vanquisher/jllutils/${__arrList[i]} jllutils/
    else
        echo "JLL: Error due to /home/jll/Vanquisher/jllutils/${__arrList[i]} is not present"
    fi
}
