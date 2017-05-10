#!/bin/bash
# Copyright(c) 2016-2100.  jielong.lin.  All rights reserved.
#
#   FileName:     jll.query.git_log_with_grep.sh
#   Author:       jielong.lin
#   Email:        493164984@qq.com
#   DateTime:     2017-04-28 14:06:53
#   ModifiedTime: 2017-05-09 12:08:18

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
#source ${JLLPATH}/BashShellLibrary

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"

function USAGE()
{
cat >&1<<EOF

     $(basename $0) [help]


    git log --raw --author=<USER_NAME>

    $(basename $0) [PATTERN]  [--author=<USER_NAME>]
    $(basename $0) [--author=<USER_NAME>] [PATTERN]


EOF
}


if [ x"$1" = x"help" ]; then
    USAGE
    exit 0
fi

#if [ x"$2" != x ]; then
#    echo "git log --raw --author=$2 | sed -n \"/$1/p\" "
#    git log --raw --author=$2 | sed -n "/$1/p" 
#else
#    echo "git log --raw | sed -n \"/$1/p\" "
#    git log --raw | sed -n "/$1/p" 
#fi

GvPattern=
GvAuthor=
for ac_arg; do
    case $ac_arg in
        --author=*)
            echo "Checking: ac_arg is $ac_arg, value=${ac_arg##--author=}"
            if [ x"${GvAuthor}" = x ]; then
                GvAuthor="--author=${ac_arg##--author=}"
            fi
            ;;
        *)
            echo "Checking: ac_arg is $ac_arg, pattern=${ac_arg}"
            if [ x"${GvPattern}" = x ]; then
                GvPattern="${ac_arg}"
            else
                GvPattern="${GvPattern}|${ac_arg}"
            fi
            ;;
    esac
done

declare -a GvCommitTable

OldIFS=${IFS}
IFS=$'\n'
GvI=0
for GvLine  in $(git log --raw  ${GvAuthor} | grep -n -E "^commit "); do
    GvCommitTable[GvI++]=${GvLine}
done
IFS=${OldIFS}

if [ ${GvI} -lt 1 ]; then
    echo
    echo "JLL: Sorry to exit due to none commit in the current git repository"
    echo
    unset GvCommitTable
    exit 0
fi

declare -a GvHitTable
IFS=$'\n'
GvK=0
for GvLine in $(git log  --raw ${GvAuthor} | grep --color -n -E "${GvPattern}"); do
    echo "JLL: Probing ${GvLine}"
    GvIdx=${GvLine%%:*}
    # Search the line number of the commit id
    for((GvJ=0; GvJ<GvI; GvJ++)) {
        GvIsMatch=0
        if [ ${GvIdx} -lt ${GvCommitTable[GvJ]%%:*} ]; then
            GvIsMatch=1
        else
            # GvIdx belong to the tail item
            if [ $((GvJ+1)) -eq ${GvI} ]; then
                echo "JLL: reach to Tail Item"
                GvIsMatch=1
                $((GvJ++))
            fi 
        fi

        if [ ${GvIsMatch} -eq 1 ]; then
            GvIsHit=0
            for((GvN=0;GvN<GvK;GvN++)) {
                if [ x"${GvHitTable[GvN]}" = x"${GvCommitTable[GvJ-1]##*:commit }" ]; then
                    GvIsHit=1;
                    break;
                fi
            }
            if [ ${GvIsHit} -eq 0 ]; then
                echo "JLL: Hit=${GvCommitTable[GvJ-1]##*:commit }"
                GvHitTable[GvK++]=${GvCommitTable[GvJ-1]##*:commit }
            fi
            break;
        fi
    }
done
unset GvCommitTable
IFS=${OldIFS}

echo
echo "======================================="
echo "JLL: Hit-Total is $GvK"
echo "======================================="
echo
for((i=0; i<GvK; i++)) {
#    echo ${GvHitTable[i]}
    git log --raw --max-count=1 ${GvHitTable[i]}
    echo
}
unset GvHitTable
