#!/bin/bash
# Copyright(c) 2016-2100.  jielong.lin.  All rights reserved.
#
#   FileName:     vicc.insight.change.sh
#   Author:       jielong.lin
#   Email:        493164984@qq.com
#   DateTime:     2016-12-28 09:22:40
#   ModifiedTime: 2016-12-28 13:06:57

JLLPATH="$(which $0)"
JLLEXEC="$(basename ${JLLPATH})"
JLLPATH="$(dirname ${JLLPATH})"
#source ${JLLPATH}/BashShellLibrary

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"

function Fn_Usage()
{
cat >&1 <<EOF

   ${JLLEXEC} <LeftPath|LeftFile>  <RightPath|RightFile>  [SpecifiedFileType] 
   #
   # @[SpecifiedFileType]:  If set, only compare path and file with suffix @[SpecifiedFileType], 
   #                        otherwise all path and files will be matched.
   #    For Example:  Compare the all head files between Path1 and Path2
   #           ${JLLEXEC} ./Path1 ./Path2  *.h
   #
   # Notice: .git or .svn is not matched by default.
 
EOF
}



if [ x"$1" != x ]; then
    if [ -e "$1" ]; then
        PVL_Left="$1"
    else
        echo
        echo "JLL.Error:  Parameter 1 \"$1\" is bad" 
        echo
        Fn_Usage
        exit 0
    fi
fi
echo
if [ x"$2" != x ]; then
    if [ -e "$2" ]; then
        PVL_Right="$2" 
    else
        echo
        echo "JLL.Error:  Parameter 2 \"$2\" is bad" 
        echo
        Fn_Usage
        exit 0
    fi
fi
echo
if [ x"${PVL_Left}" = x ]; then
    echo
    echo "JLL.Error:  not present Left-Compared-Object" 
    echo
    Fn_Usage
    exit 0
fi
if [ x"${PVL_Right}" = x ]; then
    echo
    echo "JLL.Error:  not present Right-Compared-Object" 
    echo
    Fn_Usage
    exit 0
fi
echo
PVL_Left=$(cd ${PVL_Left};pwd)
PVL_Right=$(cd ${PVL_Right};pwd)
echo
echo "${PVL_Left} <==> ${PVL_Right}"
echo

GvLeftLength=${#PVL_Left}
GvRightLength=${#PVL_Right}

_GvSuffix="$3"
if [ x"$3" != x ]; then
    _GvSuffix="${3##*.}"
fi 

cat >$(pwd)/Report_ContentChanges.viccdiff <<EOF
#!/bin/bash
# Copyright(c) 2016-2100.   jielong_lin.   All rights reserved.
clear

echo
echo "====== Menu [q: Quit] ======"
echo "[l] list the changed files"
echo "[e] edit the changed files"
echo "[q] quit"
echo
echo
read -p "YOUR CHOICE:  "  __GvMenuChoice
echo
if [ x"\${__GvMenuChoice}" = x"q" ]; then
    exit 0
fi

if [ x"\${__GvMenuChoice}" = x"l" ]; then
    echo
    echo "Left=${PVL_Left}"
    echo "Right=${PVL_Right}"
    echo "---------------------------------------------------"
fi

EOF

echo > $(pwd)/Report_FileChanges.viccdiff

_GvDiffIdx=0
__OldIFS=${IFS}
IFS=$'\n'
for _GvLine in ` diff -x".git" -x".svn" -rq ${PVL_Left} ${PVL_Right} 2>/dev/null `; do
    if [ x"${_GvLine}" = x ]; then
        continue 
    fi
    if [ x"${_GvLine:0:8}" = x"Only in " ]; then
        _GvLine=$(echo "${_GvLine}" | sed -e "s/^Only in //g" -e "s/: /\//g")
        if [ x"${_GvLine:0:${GvLeftLength}}" = x"${PVL_Left}" ]; then
            if [ x"${_GvSuffix}" != x ]; then
                if [ -f "${_GvLine}" ]; then
                    if [ x"${_GvLine##*.}" != x"${_GvSuffix}" ]; then
                        echo
                        echo "JLL-Filter: ${_GvLine} isnt file with suffix ${_GvSuffix}"
                        echo
                        continue
                     fi
                fi
            fi
            #echo "ONLY-LEFT: ${_GvLine##${PVL_Left}/}"
            #echo "${_GvLine}" >> $(pwd)/${PVL_Left//\//__}
            _GvLine=${_GvLine##${PVL_Left}/}
            echo "  ${_GvLine}" >> $(pwd)/Report_LeftFileChanges.viccdiff
            continue
        fi
        if [ x"${_GvLine:0:${GvRightLength}}" = x"${PVL_Right}" ]; then
            if [ x"${_GvSuffix}" != x ]; then
                if [ -f "${_GvLine}" ]; then
                    if [ x"${_GvLine##*.}" != x"${_GvSuffix}" ]; then
                        echo
                        echo "JLL-Filter: ${_GvLine} isnt file with suffix ${_GvSuffix}"
                        echo
                        continue
                     fi
                fi
            fi
            #echo "ONLY-RIGHT: ${_GvLine##${PVL_Right}/}"
            #echo "${_GvLine}" >> $(pwd)/${PVL_Right//\//__}
            _GvLine=${_GvLine##${PVL_Right}/}
            echo "  ${_GvLine}" >> $(pwd)/Report_RightFileChanges.viccdiff
            continue
        fi
        echo "Error @ ${_GvLine}"
        unset GvLeftLength
        unset GvRightLength
        Fn_Usage
        exit 0 
    fi
    if [ x"${_GvLine:0:6}" = x"Files " -a x"${_GvLine:0-6}" = x"differ" ]; then
        _GvLine="${_GvLine##Files }"
        _GvLine="${_GvLine%%differ}"
        if [ x"${_GvSuffix}" != x ]; then
            if [ -f "${_GvLine%% and *}" ]; then
                ___GvLine="${_GvLine%% and *}"
                if [ x"${___GvLine##*.}" != x"${_GvSuffix}" ]; then
                    echo
                    echo "JLL-Filter: ${___GvLine} isnt file with suffix ${_GvSuffix}"
                    echo
                    continue
                fi
            fi
        fi
        #echo "$_GvLine"
        __GvLeftLine=${_GvLine%% and *}
        __GvLeftLine=${__GvLeftLine##${PVL_Left}/}
        __GvRightLine=${_GvLine##* and }
        __GvRightLine=${__GvLeftLine##${PVL_Right}/}


cat >>$(pwd)/Report_ContentChanges.viccdiff <<EOF

if [ x"\${__GvMenuChoice}" = x"e" ]; then
    echo
    echo
    echo
    echo "JLLCompare-${_GvDiffIdx}::"
    echo "Left  = ${_GvLine%% and *}"
    echo "Right = ${_GvLine##* and }"
    echo
    read -p "JLL-Choice:  Perform to compare if press any, exit if press [q]:   "  __GvChoice
    if [ x"\${__GvChoice}" = x"q" ]; then
        exit 0
    fi
    vim -d \\
        ${_GvLine%% and *} \\
        ${_GvLine##* and }
fi

if [ x"\${__GvMenuChoice}" = x"l" ]; then
    echo "${_GvDiffIdx}: ${__GvLeftLine}"
fi

EOF
        _GvDiffIdx=$((_GvDiffIdx+1))
    fi
done
IFS=${__OldIFS}
echo
sed "s/JLLCompare-/Compare-${_GvDiffIdx}\./g" -i  $(pwd)/Report_ContentChanges.viccdiff
echo
if [ -e "$(pwd)/Report_LeftFileChanges.viccdiff" ]; then
    echo -e "\n\n${PVL_Left}" >> $(pwd)/Report_FileChanges.viccdiff
    cat $(pwd)/Report_LeftFileChanges.viccdiff >> $(pwd)/Report_FileChanges.viccdiff
    rm -rf $(pwd)/Report_LeftFileChanges.viccdiff
fi
if [ -e "$(pwd)/Report_RightFileChanges.viccdiff" ]; then
    echo -e "\n\n${PVL_Right}" >> $(pwd)/Report_FileChanges.viccdiff
    cat $(pwd)/Report_RightFileChanges.viccdiff >> $(pwd)/Report_FileChanges.viccdiff
    rm -rf $(pwd)/Report_RightFileChanges.viccdiff
fi
chmod +x $(pwd)/Report_ContentChanges.viccdiff
echo
exit 0

