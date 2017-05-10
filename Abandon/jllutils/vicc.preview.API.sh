#!/bin/bash
# Copyright(c) 2016-2100.  jielong.lin.  All rights reserved.
#
#   FileName:     vicc.preview.API.sh
#   Author:       jielong.lin
#   Email:        493164984@qq.com
#   DateTime:     2016-12-29 16:16:46
#   ModifiedTime: 2017-02-07 09:46:26

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"

if [ ! -e "$(pwd)/conf.vicc_preview_API" ]; then
    echo
    echo "JLL-Error:  Not present configure file named \"conf.vicc_preview_API\""
cat >&1 <<EOF

Try to fix and need to create the configure file as follows:

jielong.lin@xmbuilder03:~/workspace\$ vim ./conf.vicc_preview_API
#!/bin/bash
#

# support for regular expression:
#   such as the simila prototype "ASN1_xxx(xxxxxx)"
#
declare -a  CONF_lstRelatedAPIs=(
    "[ )=]ASN1_[a-zA-Z0-9_]{1,}[(].*[)]"
    "[ )=]Test_[a-zA-Z0-9_]{1,}\\(.*\\)[	 ]{0,}[{]{0,}]"
)

# set * to match all files
#
declare -a  CONF_lstFileType=(
    "*.c"
    "*.cpp"
)

#CONF_szRootPath="${HOME}/workspace/aosp_6.0.1_r10_selinux/device/tpvision/common/plf/mediaplayer"
CONF_szRootPath="$(pwd)"

# those ignored path is started with @CONF_szRootPath
#
#declare -i  CONF_lstIgnorePath=(
#    "external/opensource/openssl"
#    "external/third_party/wasabi"
#)

JLL-Choice:  Create the above template configure file Then edit it if press [y], or exit ?    
EOF

    read -n 1 CONF_Choice

    if [ x"${CONF_Choice}" != x"y" ]; then
        exit 0 
    fi

cat >$(pwd)/conf.vicc_preview_API<<EOF
#!/bin/bash
#

CONF_dbgEnable=0

# support for regular expression:
# 
declare -a  CONF_lstRelatedAPIs=(
    "[ )=]ASN1_[a-zA-Z0-9_]{1,}[(].*[)]"
    "[ )=]DES_[a-zA-Z0-9_]{1,}[(].*[)]"
    "[ )=]DSA_[a-zA-Z0-9_]{1,}[(].*[)]"
)


# set * to match all files
#
declare -a  CONF_lstFileType=(
    "*.c"
    "*.cpp"
)

CONF_szRootPath="${HOME}/workspace/aosp_6.0.1_r10_selinux/device/tpvision/common/plf/mediaplayer"

# those ignored path is started with @CONF_szRootPath
#
declare -i  CONF_lstIgnorePath=(
    "external/opensource/openssl"
    "external/opensource/ffmpeg/ffmpeg_1.1.1"
    "external/opensource/wasabi_oss"
    "external/third_party/wasabi"
)

EOF

chmod +x $(pwd)/conf.vicc_preview_API

vim $(pwd)/conf.vicc_preview_API

fi

if [ ! -e "$(pwd)/conf.vicc_preview_API" ]; then
    echo
    echo "JLL.Error:  Sorry due to lack of conf.vicc_preview_API"
    echo
    exit 0
fi

source $(pwd)/conf.vicc_preview_API

# check if all parameters are valid.
#
if [ x"${CONF_lstRelatedAPIs}" = x ]; then
    echo
    echo "JLL.Error:  Please define CONF_lstRelatedAPIs in conf.vicc_preview_API"
    echo
    exit 0 
fi
if [ x"${CONF_lstFileType}" = x ]; then
    echo
    echo "JLL.Error:  Please define CONF_lstFileType in conf.vicc_preview_API"
    echo
    exit 0 
fi
if [ x"${CONF_szRootPath}" = x ]; then
    echo
    echo "JLL.Error:  Please define CONF_szRootPath in conf.vicc_preview_API"
    echo
    exit 0 
fi
if [ x"${CONF_dbgEnable}" = x ]; then
    echo
    echo "JLL.Error:  Please define CONF_dbgEnable in conf.vicc_preview_API"
    echo
    exit 0 
fi




###############################################################
#   Library --- Start
###############################################################

CvPathFileForScript="`which $0`"
CvScriptName="`basename  ${CvPathFileForScript}`"
CvScriptPath="`dirname   ${CvPathFileForScript}`"

if [ x"$CvScriptPath" = x"." ]; then
    CvScriptPath="`pwd`"
fi


function Lfn_Sys_DbgEcho()
{
    LvSdeCallerFileLineNo=`caller 0 | awk '{print $1}'`
    LvSdeCallerFuncName="${FUNCNAME[1]}"
    if [ -z "$1" -o x"$1" = x"" ]; then
        echo "[jll] ${LvSdeCallerFileLineNo},${LvSdeCallerFuncName}"
    else
        echo "[jll] ${LvSdeCallerFileLineNo},${LvSdeCallerFuncName}: $1"
    fi
}

## Usage:
##     Lfn_Sys_FuncComment 
function Lfn_Sys_FuncComment()
{
    LvSfcCallerFunc="${FUNCNAME[1]}"
    LvSfcCallerFileLineNo=`caller 0 | awk '{print $1}'`
    LvSfcPattern="function ${LvSfcCallerFunc}"
    LvSfcLineNo=`grep -Enwr  "^${LvSfcPattern}" ${CvScriptPath}/${CvScriptName} | awk -F ':' '{print $1}'`
    if [ -z "${LvSfcLineNo}" ]; then
        Lfn_Sys_DbgEcho "Sorry, Return due to the bad function format" 
        return;
    fi

    LvSfcCnt=0
    for LvSfcIdx in ${LvSfcLineNo}; do
        LvSfcCnt=`expr ${LvSfcCnt} + 1`
    done
    if [ ${LvSfcCnt} -ne 1 -o ${LvSfcLineNo} -lt 0 ]; then
        Lfn_Sys_DbgEcho "Sorry, exit due to the invalid function comment format" 
        exit 0
    fi
    LvSfcContentLineNo=`expr ${LvSfcLineNo} - 1`
    if [ ${LvSfcContentLineNo} -lt 0 ]; then
        return;
    fi
    LvSfcContentStartLineNo=${LvSfcContentLineNo} 
    LvSfcContentEndLineNo=${LvSfcContentLineNo}

    while [ ${LvSfcContentStartLineNo} -ne 0 ]; do 
        LvTempContent=`sed -n "${LvSfcContentStartLineNo}p" ${CvScriptPath}/${CvScriptName} | grep -Ewn "^##"`
        if [ -z "${LvTempContent}" ]; then
            break;
        fi
        LvSfcContentStartLineNo=`expr ${LvSfcContentStartLineNo} - 1`
    done
 
    if [ ${LvSfcContentStartLineNo} -lt ${LvSfcContentEndLineNo} ]; then
        echo "Error LineNo : ${LvSfcCallerFileLineNo}"
        LvSfcContentStartLineNo=`expr ${LvSfcContentStartLineNo} + 1`
        sed -n "${LvSfcContentStartLineNo},${LvSfcContentEndLineNo}p" ${CvScriptPath}/${CvScriptName} | sed 's/^#\{0,\}//'
    fi
    return;
}

  #----------------------------------
  # ANSI Control Code
  #----------------------------------
  #   \033[0m 关闭所有属性
  #   \033[01m 设置高亮度
  #   \033[04m 下划线
  #   \033[05m 闪烁
  #   \033[07m 反显
  #   \033[08m 消隐
  #   \033[30m -- \033[37m 设置前景色
  #   \033[40m -- \033[47m 设置背景色
  #   \033[nA 光标上移n行
  #   \033[nB 光标下移n行
  #   \033[nC 光标右移n行
  #   \033[nD 光标左移n行
  #   \033[y;xH 设置光标位置
  #   \033[2J 清屏
  #   \033[K  清除从光标到行尾的内容
  #   \033[s  保存光标位置
  #   \033[u  恢复光标位置
  #   \033[?25l 隐蔽光标
  #   \033[?25h 显示光标
  #-----------------------------------


  # 黑:Black
  # 红:Red
  # 绿:Green
  # 黄:Yellow
  # 蓝:Blue
  # 粉红:Pink
  # 海蓝:SeaBlue
  # 白:White

CvAccOff="\033[0m"

CvFgBlack="\033[30m"
CvFgRed="\033[31m"
CvFgGreen="\033[32m"
CvFgYellow="\033[33m"
CvFgBlue="\033[34m"
CvFgPink="\033[35m"
CvFgSeaBule="\033[36m"
CvFgWhite="\033[37m"

CvBgBlack="\033[40m"
CvBgRed="\033[41m"
CvBgGreen="\033[42m"
CvBgYellow="\033[43m"
CvBgBlue="\033[44m"
CvBgPink="\033[45m"
CvBgSeaBule="\033[46m"
CvBgWhite="\033[47m"


## Usage:
##     Lfn_Sys_DbgColorEcho [CvFgXxx|CvBgXxx] [CvFgXxx|CvBgXxx] [TEXT] 
## Details:
##     Print the format <TEXT> with fg-color named [CvFgXxx] or bg-color named [CvBgXxx]
## Parameter:
##     [CvFgXxx]   - Foreground color
##     [CvBgXxx]   - Background color 
##     [TEXT] - The text to display on the standard output device.
## Example:
##     Lfn_Sys_DbgColorEcho ${CvFgRed} ${CvBgWhite} "hello World"
##
function Lfn_Sys_DbgColorEcho()
{
    LvSdceCallerFileLineNo=`caller 0 | awk '{print $1}'`
    LvSdceCallerFuncName="${FUNCNAME[1]}"

    LvSdceFgColor=""
    LvSdceBgColor=""
    LvSdceText=""

    while [ $# -ne 0 ]; do
    case $1 in
    "\033[3"*)
        if [ -z "${LvSdceFgColor}" ]; then
            LvSdceFgColor=$1
        fi
        ;;
    "\033[4"*)
        if [ -z "${LvSdceBgColor}" ]; then
            LvSdceBgColor=$1
        fi
        ;;
    *)
        if [ -z "${LvSdceText}" ]; then
            LvSdceText=$1
        fi 
        ;;
    esac
    shift
    done

    if [ -z "${LvSdceText}" ]; then 
        echo -e "${CvAccOff}${LvSdceFgColor}${LvSdceBgColor}"\
                "\b[jll] ${LvSdceCallerFileLineNo},${LvSdceCallerFuncName}${CvAccOff}" 
    else
        echo -e "${CvAccOff}${LvSdceFgColor}${LvSdceBgColor}"\
                "\b[jll] ${LvSdceCallerFileLineNo},${LvSdceCallerFuncName}: ${LvSdceText}${CvAccOff}" 
    fi
}


## Usage:
##     Lfn_Sys_ColorEcho [CvFgXxx|CvBgXxx] [CvFgXxx|CvBgXxx] [TEXT] 
## Details:
##     Print the format <TEXT> with fg-color named [CvFgXxx] or bg-color named [CvBgXxx]
## Parameter:
##     [CvFgXxx]   - Foreground color
##     [CvBgXxx]   - Background color 
##     [TEXT] - The text to display on the standard output device.
## Example:
##     Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello World"
##
function Lfn_Sys_ColorEcho()
{
    LvSceFgColor=""
    LvSceBgColor=""
    LvSceText=""

    while [ $# -ne 0 ]; do
    case $1 in
    "\033[3"*)
        if [ -z "${LvSceFgColor}" ]; then
            LvSceFgColor=$1
        fi
        ;;
    "\033[4"*)
        if [ -z "${LvSceBgColor}" ]; then
            LvSceBgColor=$1
        fi
        ;;
    *)
        if [ -z "${LvSceText}" ]; then
            LvSceText=$1
        fi 
        ;;
    esac
    shift
    done

    echo -e "${CvAccOff}${LvSceFgColor}${LvSceBgColor}${LvSceText}${CvAccOff}" 
}

## Usage:
##     Lfn_File_SearchSymbol_EX --Symbol=<SYMBOL>  \\
##         --File=<ScopeFiles...> \\
##         --Mode=<MatchMode> \\
##         --Path=<PathString>
##         --Ignore=<IgnorePath...> \\
## Details:
##     Search the <SYMBOL> from <ScopeFiles...> as <MatchMode>
##     output the matched information. 
## Parameter:
##     <SYMBOL> - specified symbol used for matching search file location.
##                Support for regular expression
##     <ScopeFile> - specified the files used to be searched.
##     <MatchMode> - specified the matching as precise or comprehensive.
##                   one of the values:
##                   0 - precise (default)
##                   1 - comprehensive
##     <PathString> - search path
##     <IgnorePath> - ignore path to match
## Notice:
##     IgnorePath is based on start with PathString, so PathString should be put before IgnorePath
##
## 
## Example:
##     Lfn_File_SearchSymbol_EX --Symbol="main"  --File=*.c \
##         --File=*.java --File=*.cpp --Mode=0 --Path=/home/jll --Ignore=test
##
function Lfn_File_SearchSymbol_EX()
{
    CvPreciseFlags="-Ewnr"
    CvComprehensiveFlags="-Enr"

    LvFssSymbol=""
    LvFssFile=""
    LvFssFileSwitch=1
    LvFssMode="0"
    LvFssIgnorePath=""
    LvFssIgnorePathCnt=0
    LvFssFlags="${CvPreciseFlags}"
    LvFssRootPath="$(pwd)"

    while [ $# -ne 0 ]; do
    case $1 in
    --Path=*)
        LvFssRootPath=`echo $1 | sed -e "s/--Path=//g" -e "s/,/ /g"`
        ;; 
    --Symbol=*)
        if [ -z "${LvFssSymbol}" ]; then
            LvFssSymbol=`echo $1 | sed -e "s/--Symbol=//g"`
        fi
        ;;
    --File=*)
        if [ x"${LvFssFileSwitch}" = x"1" ]; then
            LvFssTempFileString="`echo $1 | sed -e 's/--File=//g' -e 's/,/ /g'`"
            if [ x"${LvFssTempFileString}" = x"*" ]; then
                LvFssFile="*"
                LvFssFileSwitch=0
            else 
                if [ ! -z "${LvFssTempFileString}" ]; then
                    LvFssFile="${LvFssFile} ${LvFssTempFileString}"
                fi
            fi
        fi
        ;;
    --Mode=*)
        LvFssMode=`echo $1 | sed -e "s/--Mode=//g" -e "s/,/ /g"`
        ;;
    --Ignore=*)
        LvFssIgnores="`echo $1 | sed -e 's/--Ignore=//g' -e 's/,/ /g'`"
        if [ x"${LvFssIgnores}" != x ]; then
            LvFssIgnores="${LvFssIgnores//\"/}"
            if [ -e "${LvFssRootPath}/${LvFssIgnores}" ]; then
                #echo "jll: --Ignore=${LvFssIgnores}"
                if [ x"${LvFssIgnorePath}" = x ]; then
                  LvFssIgnorePath="-path \"${LvFssRootPath}/${LvFssIgnores}\""
                  LvFssIgnorePathCnt=1
                else
                  LvFssIgnorePath="${LvFssIgnorePath} -o -path \"${LvFssRootPath}/${LvFssIgnores}\""
                  LvFssIgnorePathCnt=$((LvFssIgnorePathCnt+1))
                fi
            else
                echo "jll: not present ignore path=${LvFssRootPath}/${LvFssIgnores}"
            fi
        fi
        ;;
    *)
        ;;
    esac
    shift
    done
    #echo "jll: --Ignore=${LvFssIgnorePath}"
    if [ x"${LvFssIgnorePath}" != x ]; then
        if [ ${LvFssIgnorePathCnt} -gt 1 ]; then
            LvFssIgnorePath="\\( ${LvFssIgnorePath} \\) -prune -o"
        else
            if [ ${LvFssIgnorePathCnt} -eq 1 ]; then
                LvFssIgnorePath="${LvFssIgnorePath} -prune -o"
            else
                LvFssIgnorePath=""
            fi
        fi
    fi

    if [ -z "${LvFssSymbol}" -o -z "${LvFssFile}" ]; then
        Lfn_Sys_FuncComment
        return;
    fi

    if [ x"${LvFssMode}" = x"1" ]; then
        LvFssFlags=${CvComprehensiveFlags}
    fi

    if [ x"${LvFssFile}" = x"*" ]; then
        echo
        echo
        echo "jll: maybe take more long time to find all files by *"
      if [ x"${CONF_dbgEnable}" = x"1" ]; then
        Lfn_Sys_ColorEcho ${CvFgPink} ${CvBgBlack} \
            "find ${LvFssRootPath} ${LvFssIgnorePath} -type f -a -print"
        Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgBlack} \
            "---> grep ${LvFssFlags} \"${LvFssSymbol}\""
      fi
        __OldIFS=${IFS}
        IFS=$'\n'
        for LvFssLine in \
        `eval find ${LvFssRootPath} ${LvFssIgnorePath} -type f -a -print`; do
            LvFssMatch=`grep ${LvFssFlags} "${LvFssSymbol}" "${LvFssLine}" --color=always`
            if [ x"$?" = x"0" ]; then
                Lfn_Sys_ColorEcho  ${CvFgBlack}  ${CvBgWhite}    " ${LvFssLine} "
                Lfn_Sys_ColorEcho  "${LvFssMatch}"
                echo
            fi
        done
        echo
        Lfn_Sys_ColorEcho ${CvBgRed} ${CvFgYellow} " Done"
        echo
        exit 0
    fi


    for LvFssFl in ${LvFssFile}; do
      if [ x"${CONF_dbgEnable}" = x"1" ]; then
        echo
        echo
        Lfn_Sys_ColorEcho ${CvFgPink} ${CvBgBlack} \
            "find ${LvFssRootPath} ${LvFssIgnorePath} -type f -a -name \"${LvFssFl}\" -print"
        Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgBlack} \
            "---> grep ${LvFssFlags} \"${LvFssSymbol}\""
      fi
        __OldIFS=${IFS}
        IFS=$'\n'
        for LvFssLine in \
        `eval find ${LvFssRootPath} ${LvFssIgnorePath} -type f -a -name "${LvFssFl}" -print`; do
            LvFssMatch=`grep ${LvFssFlags} "${LvFssSymbol}" "${LvFssLine}" --color=always`
            if [ x"$?" = x"0" ]; then
                Lfn_Sys_ColorEcho  ${CvFgBlack}  ${CvBgWhite}    " ${LvFssLine} "
                Lfn_Sys_ColorEcho  "${LvFssMatch}"
                echo
            fi
        done
        IFS=${__OldIFS}
    done
    if [ x"${CONF_dbgEnable}" = x"1" ]; then
        echo
        Lfn_Sys_ColorEcho ${CvBgRed} ${CvFgYellow} " Done"
        echo
    fi
}






echo
echo -e "${CvAccOff}${CvFgPink}${CvBgBlack}JLL-Search-API-Symbol:${CvAccOff}" 
__nRelatedAPIs=${#CONF_lstRelatedAPIs[@]}
for((i=0; i<__nRelatedAPIs; i++)) {
    echo "${CONF_lstRelatedAPIs[i]}"
}




__szConsiderFileType=""
__nLstConsiderFileType=${#CONF_lstFileType[@]}
for((i=0; i<__nLstConsiderFileType; i++)) {
    __szConsiderFileType="${__szConsiderFileType} --File=\"${CONF_lstFileType[i]}\""
}

echo
if [ x"${__szConsiderFileType}" = x ]; then
    __szConsiderFileType="*"
fi
echo -ne "${CvAccOff}${CvFgPink}${CvBgBlack}JLL-FileType:${CvAccOff}" 
echo -e "${__szConsiderFileType// --File=/\\n}" | sed "s/\"//g"
echo


echo
echo -e "${CvAccOff}${CvFgPink}${CvBgBlack}JLL-Search-RootPath:${CvAccOff}" 
echo -e "${CONF_szRootPath}"
echo

if [ x"${CONF_lstIgnorePath}" != x ]; then
    __nLstIgnorePath=${#CONF_lstIgnorePath[@]}
    for((i=0; i<__nLstIgnorePath; i++)) {
        __szIgnorePath="${__szIgnorePath} --Ignore=\"${CONF_lstIgnorePath[i]}\""
    }
    echo
    echo -ne "${CvAccOff}${CvFgPink}${CvBgBlack}JLL-Ignore:${CvAccOff}" 
    echo -e "${__szIgnorePath// --Ignore=/\\n}" | sed "s/\"//g"
    echo
else
    __szIgnorePath=""
fi


__nRelatedAPIs=${#CONF_lstRelatedAPIs[@]}
for((i=0; i<__nRelatedAPIs; i++)) {
   Lfn_File_SearchSymbol_EX \
       ${__szConsiderFileType} \
       --Symbol="${CONF_lstRelatedAPIs[i]}" \
       --Mode=1 \
       --Path="${CONF_szRootPath}" \
       ${__szIgnorePath}
}


