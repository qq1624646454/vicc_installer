#!/bin/bash
# Copyright (c) 2016-2100,  jielong_lin,  All rights reserved.
#
JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
JLLPATH=$(cd ${JLLPATH};pwd)

#
# Setup AutoSync 
#
function Fn_Setup_AutoSync()
{
    crontab -l  > tsk.crontab  2>/dev/null
    if [ -e "${JLLPATH}/._______auto_sync_by_GIT__in_crontab.sh" ]; then
        __chk_if_exist=$(cat tsk.crontab \
                         | grep -E "${JLLPATH}/._______auto_sync_by_GIT__in_crontab.sh")
        if [ x"${__chk_if_exist}" = x ]; then
cat >>tsk.crontab<<EOF

# m  h  dom mon dow command
  0  6  *   *   *   ${JLLPATH}/._______auto_sync_by_GIT__in_crontab.sh

EOF
            crontab tsk.crontab
        fi
        rm -rf tsk.crontab
        echo
        crontab -l 
        echo
    fi

    unset GvTargetLines
}

Fn_Setup_AutoSync

