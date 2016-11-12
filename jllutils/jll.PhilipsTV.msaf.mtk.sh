#!/bin/bash
# Copyright (c) 2016-2100,  jielong_lin,  All rights reserved.
#
JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
source ${JLLPATH}/BashShellLibrary


#
# Location the which project associated with PhilipsTV
#
GvRootPath=$(realpath ~)
if [ ! -e "${GvRootPath}" ]; then
    Lfn_Sys_DbgEcho "Sorry, Exit due to dont exist user \"~\" path"
    exit 0
fi

# Find the same level path which contains .repo folder
Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
if [ ! -e "${GvPrjRootPath}" ]; then
    Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
    Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
    exit 0
fi
echo

GvRepoPath="${GvRootPath##${GvPrjRootPath}}"

## Fn_Sort_ThreeFields_SplitByDot  "<PrefixString>"  "<Descend>|<Ascend>"
##
## The result will be stored into GvPageMenuUtilsContent
## E.G.:
##        declare -a GvPageMenuUtilsContent=(
##            "QM16XE_U_R0.10.3.1"
##            "QM16XE_U_R0.9.2.1"
##            "QM16XE_U_R0.10.10.0"
##        )
##        Fn_Sort_ThreeFields_SplitByDot "QM16XE_U_R0" "Ascend"
##        Lfn_PageMenuUtils GvResult  "Select" 7 4 "***** List  (q: quit) *****"
##
function Fn_Sort_ThreeFields_SplitByDot()
{
    if [ x"${GvPageMenuUtilsContent[0]}" = x ]; then
        echo
        echo "JLL-Check@ Undefine GvPageMenuUtilsContent"
        echo
        exit 0
    fi

    if [ $# -ne 2 ]; then
        echo
        echo "JLL-Check@ Not obey Function Prototype"
        echo
        exit 0
    fi

    if [ x"$2" = x"Descend" ]; then
        echo
        echo "JLL-Sort@ All Versions are Sorting by descending, Please wait..."
        echo
        __Li4Count=${#GvPageMenuUtilsContent[@]}
        for ((i=0; i<__Li4Count; i++)) {
            __LvEntryBig=${GvPageMenuUtilsContent[i]}
            __LvF3=${__LvEntryBig##$1.}    # "QM16XE_U_R0." is removed from "QM16XE_U_R0.10.3.1" 
            __LvF1=${__LvF3%%.*}           # ".3.1" is removed from "10.3.1", 10
            __LvF3=${__LvF3#${__LvF1}.}     # "10." is removed from "10.3.1", 3.1
            __LvF2=${__LvF3%%.*}           # ".1" is removed from "3.1"
            __LvF3=${__LvF3#${__LvF2}.}     # "3." is removed from "3.1", 1
            __LvF3=${__LvF3%%_*}     # "_xx" is removed from "1_xx", 1
            __LvF3=${__LvF3%%.*}     # ".xx" is removed from "1.xx", 1
            __Li4Big=$((__LvF1 * 1000000 + __LvF2 * 1000 + __LvF3 * 1))
            for ((j=i+1; j<__Li4Count; j++)) {
                __LvEntrySmall=${GvPageMenuUtilsContent[j]}
                __LvF3=${__LvEntrySmall##$1.}
                __LvF1=${__LvF3%%.*}           # ".3.1" is removed from "10.3.1", 10
                __LvF3=${__LvF3#${__LvF1}.}     # "10." is removed from "10.3.1", 3.1
                __LvF2=${__LvF3%%.*}           # ".1" is removed from "3.1"
                __LvF3=${__LvF3#${__LvF2}.}     # "3." is removed from "3.1", 1
                __LvF3=${__LvF3%%_*}     # "_xx" is removed from "1_xx", 1
                __LvF3=${__LvF3%%.*}     # ".xx" is removed from "1.xx", 1
                __Li4Small=$((__LvF1 * 1000000 + __LvF2 * 1000 + __LvF3 * 1))
                if [ ${__Li4Small} -gt ${__Li4Big} ]; then
                    __LvTemp=${GvPageMenuUtilsContent[i]}
                    GvPageMenuUtilsContent[i]="${GvPageMenuUtilsContent[j]}"
                    GvPageMenuUtilsContent[j]="${__LvTemp}"
                    __LvEntryBig=${GvPageMenuUtilsContent[i]}
                    __LvF3=${__LvEntryBig##$1.}
                    __LvF1=${__LvF3%%.*}           # ".3.1" is removed from "10.3.1", 10
                    __LvF3=${__LvF3#${__LvF1}.}     # "10." is removed from "10.3.1", 3.1
                    __LvF2=${__LvF3%%.*}           # ".1" is removed from "3.1"
                    __LvF3=${__LvF3#${__LvF2}.}     # "3." is removed from "3.1", 1
                    __LvF3=${__LvF3%%_*}     # "_xx" is removed from "1_xx", 1
                    __LvF3=${__LvF3%%.*}     # ".xx" is removed from "1.xx", 1
                    __Li4Big=$((__LvF1 * 1000000 + __LvF2 * 1000 + __LvF3 * 1))
                fi
            }
        }
    fi
    if [ x"$2" = x"Ascend" ]; then
        echo
        echo "JLL-Sort@ All Versions are Sorting by ascending, Please wait..."
        echo
        __Li4Count=${#GvPageMenuUtilsContent[@]}
        for ((i=0; i<__Li4Count; i++)) {
            __LvEntrySmall=${GvPageMenuUtilsContent[i]}
            __LvF3=${__LvEntrySmall##$1.}    # "QM16XE_U_R0." is removed from "QM16XE_U_R0.10.3.1" 
            __LvF1=${__LvF3%%.*}           # ".3.1" is removed from "10.3.1", 10
            __LvF3=${__LvF3#${__LvF1}.}     # "10." is removed from "10.3.1", 3.1
            __LvF2=${__LvF3%%.*}           # ".1" is removed from "3.1"
            __LvF3=${__LvF3#${__LvF2}.}     # "3." is removed from "3.1", 1
            __LvF3=${__LvF3%%_*}     # "_xx" is removed from "1_xx", 1
            __LvF3=${__LvF3%%.*}     # ".xx" is removed from "1.xx", 1
            __Li4Small=$((__LvF1 * 1000000 + __LvF2 * 1000 + __LvF3 * 1))
            for ((j=i+1; j<__Li4Count; j++)) {
                __LvEntryBig=${GvPageMenuUtilsContent[j]}
                __LvF3=${__LvEntryBig##$1.}
                __LvF1=${__LvF3%%.*}           # ".3.1" is removed from "10.3.1", 10
                __LvF3=${__LvF3#${__LvF1}.}     # "10." is removed from "10.3.1", 3.1
                __LvF2=${__LvF3%%.*}           # ".1" is removed from "3.1"
                __LvF3=${__LvF3#${__LvF2}.}     # "3." is removed from "3.1", 1
                __LvF3=${__LvF3%%_*}     # "_xx" is removed from "1_xx", 1
                __LvF3=${__LvF3%%.*}     # ".xx" is removed from "1.xx", 1
                __Li4Big=$((__LvF1 * 1000000 + __LvF2 * 1000 + __LvF3 * 1))
                if [ ${__Li4Small} -gt ${__Li4Big} ]; then
                    __LvTemp=${GvPageMenuUtilsContent[i]}
                    GvPageMenuUtilsContent[i]="${GvPageMenuUtilsContent[j]}"
                    GvPageMenuUtilsContent[j]="${__LvTemp}"
                    __LvEntrySmall=${GvPageMenuUtilsContent[i]}
                    __LvF3=${__LvEntrySmall##$1.}
                    __LvF1=${__LvF3%%.*}           # ".3.1" is removed from "10.3.1", 10
                    __LvF3=${__LvF3#${__LvF1}.}     # "10." is removed from "10.3.1", 3.1
                    __LvF2=${__LvF3%%.*}           # ".1" is removed from "3.1"
                    __LvF3=${__LvF3#${__LvF2}.}     # "3." is removed from "3.1", 1
                    __LvF3=${__LvF3%%_*}     # "_xx" is removed from "1_xx", 1
                    __LvF3=${__LvF3%%.*}     # ".xx" is removed from "1.xx", 1
                    __Li4Small=$((__LvF1 * 1000000 + __LvF2 * 1000 + __LvF3 * 1))
                fi
            }
        }
    fi
}




function Fn_Mediatek_VersionInfo()
{
cat >&1 << EOF

 $ vim apollo/sys_build/tpv/PH7M_EU_5596/Makefile
 ...
 759 # path customization for project_x/target/$(OS_TARGET)
 760 export OS_TARGET      := linux-2.6.18
 761
 762 TARGET         := linux_mak
 763 BUILD_NAME     := PH7M_EU_5596 apollo-mp-1501-1550-5-001-15-001-206-001
 764 MODEL_NAME     := PH7M_EU_5596
 765 CUSTOMER       := tpv
 766 CUSTOM         := philips/tpv/EU
 767 CUST_MODEL     := $(MODEL_NAME)
 768 SERIAL_NUMBER  := IDTV
 769 THIS_ROOT      := $(shell pwd)
 ...

EOF

    declare -a GvMenuUtilsContent
    declare -i GvMenuUtilsContentCnt=0
 
    #
    # Checking if the project is valid
    #
    LvmvVariable="${GvPrjRootPath}/apollo/sys_build/tpv"
    if [ ! -e "${LvmvVariable}" ]; then
        Lfn_Sys_DbgEcho "Checking @ Not Exist ' ${GvPrjRootPath}/apollo/sys_build/tpv '"
        unset LvmvVariable
        unset GvMenuUtilsContent
        unset GvMenuUtilsContentCnt
        return
    fi
    if [ -e "${LvmvVariable}" ]; then
        LvmvSubVariable="$(cd ${LvmvVariable};ls)"
        for LvmvSubV in ${LvmvSubVariable}; do
            LvmvFlags="${LvmvVariable}/${LvmvSubV}/Makefile"
            if [ -e "${LvmvFlags}" ]; then
               GvMenuUtilsContent[GvMenuUtilsContentCnt]="${LvmvSubV}"
               GvMenuUtilsContentCnt=$(( GvMenuUtilsContentCnt + 1 ))
            fi
            unset LvmvFlags
        done
        unset LvmvSubV
        unset LvmvSubVariable
        if [ ${GvMenuUtilsContentCnt} -lt 1 ]; then
            Lfn_Sys_DbgEcho "Checking @ ${LvmvVariable}"
            Lfn_Sys_DbgEcho "Checking Fail: Do not find any valid project"
            unset GvMenuUtilsContent
            unset GvMenuUtilsContentCnt
            unset LvmvVariable
            unset GvPrjRootPath
            unset GvRootPath
            exit 0
        fi
        echo "Checking OK: ${LvmvVariable}"
     else
        Lfn_Sys_DbgEcho "Checking Fail: ${LvmvVariable}"
        unset GvMenuUtilsContent
        unset GvMenuUtilsContentCnt
        unset LvmvVariable
        unset GvPrjRootPath
        unset GvRootPath
        exit 0
    fi

    Lfn_MenuUtils LvmvResult  "Select" 7 4 "***** PhilipsTV Project List (q: quit) *****"
    LvmvSym="export VERSION"
    LvmvSoftwareVersion=$(cat ${LvmvVariable}/${LvmvResult}/Makefile | grep -i "${LvmvSym}" | awk -F '=' '{print $2}')
    if [ x"${LvmvSoftwareVersion}" = x ]; then
        LvmvSym="BUILD_NAME"
        LvmvSoftwareVersion=$(cat ${LvmvVariable}/${LvmvResult}/Makefile | grep -i "${LvmvSym}" | awk -F '=' '{print $2}')
    fi
    clear
    echo ""
    echo "++++++ ${LvmvResult} - Mediatek Software Version ++++++"
    echo "  ${LvmvSym}=${LvmvSoftwareVersion}"
    echo ""

    unset LvmvSym
    unset LvmvVariable
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
}


function Fn_PhilipsTV_VersionInfo()
{
    declare -a GvMenuUtilsContent
    declare -i GvMenuUtilsContentCnt=0
    #
    # Checking if the project is valid
    #
    LvpvVariable="${GvPrjRootPath}/android/m-base/device/tpv"
    if [ ! -e "${LvpvVariable}" ]; then
        Lfn_Sys_DbgEcho "Checking @ Not Exist ' ${GvPrjRootPath}/apollo/sys_build/tpv '"
        unset LvpvVariable
        unset GvMenuUtilsContent
        unset GvMenuUtilsContentCnt
        return
    fi
    if [ -e "${LvpvVariable}" ]; then
        LvpvSubVariable="$(cd ${LvpvVariable};ls)"
        for LvpvSubV in ${LvpvSubVariable}; do
            LvpvFlags="${LvpvVariable}/${LvpvSubV}/system.prop"
            if [ -e "${LvpvFlags}" ]; then
               GvMenuUtilsContent[GvMenuUtilsContentCnt]="${LvpvSubV}"
               GvMenuUtilsContentCnt=$(( GvMenuUtilsContentCnt + 1 ))
            fi
            unset LvpvFlags
        done
        unset LvpvSubV
        unset LvpvSubVariable
        if [ ${GvMenuUtilsContentCnt} -lt 1 ]; then
            Lfn_Sys_DbgEcho "Checking @ ${LvpvVariable}"
            Lfn_Sys_DbgEcho "Checking Fail: Do not find any valid project"
            unset GvMenuUtilsContent
            unset GvMenuUtilsContentCnt
            unset LvpvVariable
            unset GvPrjRootPath
            unset GvRootPath
            exit 0
        fi
        echo "Checking OK: ${LvpvVariable}"
    else
        Lfn_Sys_DbgEcho "Checking Fail: ${LvpvVariable}"
        unset GvMenuUtilsContent
        unset GvMenuUtilsContentCnt
        unset LvpvVariable
        unset GvPrjRootPath
        unset GvRootPath
        exit 0
    fi

    Lfn_MenuUtils LvpvResult  "Select" 7 4 "***** PhilipsTV Project List (q: quit) *****"
    LvpvSym="ro.tpvision.product.swversion"
    LvpvSoftwareVersion=$(cat ${LvpvVariable}/${LvpvResult}/system.prop | grep -i "${LvpvSym}" | awk -F '=' '{print $2}')
    clear
    echo ""
    echo "++++++ ${LvpvResult} - PhilipsTV Software Version ++++++"
    echo "  ${LvpvSym}=${LvpvSoftwareVersion}"
    echo ""

    unset LvpvSym
    unset LvpvVariable
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
}


##
##    Fn_PhilipsTV_Make_Full_UPG
##
function Fn_PhilipsTV_Make_Full_UPG()
{
    if [ ! -e "${GvPrjRootPath}/build/envsetup.sh" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "File=\"${GvPrjRootPath}/build/envsetup.sh\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find the above file" 
        exit 0
    fi

    if [ ! -e "${GvPrjRootPath}/out/mediatek_linux/output/upgrade_loader.pkg" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Please first compile source codes to out/mediatek_linux/output/upgrade_loader.pkg"
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Can't find \"${GvPrjRootPath}/out/mediatek_linux/output/upgrade_loader.pkg\""
        exit 0 
    fi
    if [ ! -e  "${GvPrjRootPath}/device/tpvision/common/sde/upg/upgmaker.sh" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "File=\"${GvPrjRootPath}/device/tpvision/common/sde/upg/upgmaker.sh\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find the above file" 
        exit 0
    fi
 
    clear
    echo
    cd ${GvPrjRootPath}
    if [ x"${TARGET_PRODUCT}" = x ]; then
        source build/envsetup.sh 
        lunch
        echo
    fi
    cd device/tpvision/common/sde/upg/
    echo >> ${GvPrjRootPath}/make.mtk_build.log
    echo "------ Make upg Image @$(date +%Y_%m_%d__%H_%M_%S)-------" >> ${GvPrjRootPath}/make.mtk_build.log
    ./upgmaker.sh ${TARGET_PRODUCT} r f  2>&1|tee -a ${GvPrjRootPath}/make.mtk_build.log
}


##
##    Fn_PhilipsTV_Make_Tool_UPG
##
function Fn_PhilipsTV_Make_Tool_UPG()
{
    if [ ! -e "${GvPrjRootPath}/build/envsetup.sh" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "File=\"${GvPrjRootPath}/build/envsetup.sh\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find the above file" 
        exit 0
    fi

    if [ ! -e "${GvPrjRootPath}/out/mediatek_linux/output/upgrade_loader.pkg" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Please first compile source codes to out/mediatek_linux/output/upgrade_loader.pkg"
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Can't find \"${GvPrjRootPath}/out/mediatek_linux/output/upgrade_loader.pkg\""
        exit 0 
    fi
    if [ ! -e  "${GvPrjRootPath}/device/tpvision/common/sde/upg/upgmaker.sh" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "File=\"${GvPrjRootPath}/device/tpvision/common/sde/upg/upgmaker.sh\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find the above file" 
        exit 0
    fi
 
    clear
    echo
    cd ${GvPrjRootPath}
    if [ x"${TARGET_PRODUCT}" = x ]; then
        source build/envsetup.sh 
        lunch
        echo
    fi
    cd device/tpvision/common/sde/upg/
    echo >> ${GvPrjRootPath}/make.mtk_build.log
    echo "------ Make upg Image @$(date +%Y_%m_%d__%H_%M_%S)-------" >> ${GvPrjRootPath}/make.mtk_build.log
    ./upgmaker.sh ${TARGET_PRODUCT} r t  2>&1|tee -a ${GvPrjRootPath}/make.mtk_build.log
}






##
##    Fn_PhilipsTV_Compilation
##
function Fn_PhilipsTV_Compilation()
{
    if [ ! -e "${GvPrjRootPath}/android/m-base/build/envsetup.sh" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "File=\"${GvPrjRootPath}/android/m-base/build/envsetup.sh\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find the above file" 
        exit 0
    fi


    declare -a GvMenuUtilsContent=(
        "Build_pkg:                            make -j8 mtk_build"
        "Clean:                                make -j8 mtk_clean"
        "ExoPlayerWrapper-ContentExplorer:     compile exoplayerwrapper and contentexplorer"
        "Usage:                                compilation usage manual"
    )
    GvMenuUtilsContentCnt=${#GvMenuUtilsContent[@]}

    while [ 1 -eq 1 ]; do
        Lfn_MenuUtils GvResult  "Select" 7 4 "***** Execute Action MENU (q: quit no matter what) *****"
        if [ x"${GvResult}" = x"${GvMenuUtilsContent[0]}" ]; then
            clear
            echo
            cd ${GvPrjRootPath}/android/m-base
            set_M
            source build/envsetup.sh 
            lunch
            echo
            make -j8 mtk_build 2>&1|tee make.mtk_build.log
            echo
        fi
        if [ x"${GvResult}" = x"${GvMenuUtilsContent[1]}" ]; then
            clear
            echo
            cd ${GvPrjRootPath}/android/m-base
            set_M
            source build/envsetup.sh 
            lunch
            echo
            rm -rf make.mtk_*.log
            echo
            if [ -e "${GvPrjRootPath}/__${TARGET_PRODUCT}_Upg_Retail" ]; then
                read -p "JLL: Remove \"${GvPrjRootPath}/__${TARGET_PRODUCT}_Upg_Retail if press [y]?  " LvChoice
                if [ x"${LvChoice}" = x"y" ]; then
                    rm -rvf ${GvPrjRootPath}/__${TARGET_PRODUCT}_Upg_Retail 
                fi
            fi
            echo 
            make -j8 mtk_clean 2>&1|tee make.mtk_clean.log
            echo
            if [ -e "${GvPrjRootPath}/out" ]; then
                read -p "JLL: Remove \"${GvPrjRootPath}/out if press [y]?  " LvChoice
                if [ x"${LvChoice}" = x"y" ]; then
                    rm -rvf ${GvPrjRootPath}/out
                fi
            fi
            echo
        fi
        if [ x"${GvResult}" = x"${GvMenuUtilsContent[2]}" ]; then
            clear
            echo
            cd ${GvPrjRootPath}/android/m-base
            set_M
            source build/envsetup.sh 
            lunch
            echo
            cd ${GvPrjRootPath}/android/m-base/device/tpv/common/plf/exoplayer/exoplayerwrapper
            mm -B 2>&1|tee    ${GvPrjRootPath}/android/m-base/exoplayerwrapper_contentexplorer.log
            echo
            cd ${GvPrjRootPath}/android/m-base/device/tpv/common/app/contentexplorer
            mm -B 2>&1|tee -a ${GvPrjRootPath}/android/m-base/exoplayerwrapper_contentexplorer.log
            cd - >/dev/null
            echo
        fi
       if [ x"${GvResult}" = x"${GvMenuUtilsContent[3]}" ]; then
            clear
cat >&1 <<EOF

      cd ${GvPrjRootPath}/android/m-base
      set_M
      source build/envsetup.sh 
      lunch
  
      make -j8 mtk_clean 2>&1 | tee make.mtk_clean.log

      make -j8 mtk_build 2>&1 | tee make.mtk_build.log

EOF
        fi
        read -t 5 -p "JLL: Back to Execute Action Menu if press [y]?  " LvChoice
        if [ x"${LvChoice}" = x"y" ]; then
            continue
        fi
        break
    done

    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
}


declare -a GvMenuUtilsContent=(
    "Query Software Version"
    "Query Mediatek Version"
    "Compilation: make or make clean"
    "Reset And Clean Code Changes For Current Git Branch"
    "All Git Repositores Status"
    "Sync Latest Code And Checkout Version Into TPM171E_R.0.xxx.yyy.zzz"
)
Lfn_MenuUtils GvResult  "Select" 7 4 "***** MENU (q: quit no matter what) *****"

if [ x"${GvResult}" = x"${GvMenuUtilsContent[0]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    clear
    echo
    Fn_PhilipsTV_VersionInfo
    echo
    exit 0
fi

if [ x"${GvResult}" = x"${GvMenuUtilsContent[1]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    clear
    echo
    Fn_Mediatek_VersionInfo
    echo
    exit 0
fi


if [ x"${GvResult}" = x"${GvMenuUtilsContent[2]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    clear
    echo
    Fn_PhilipsTV_Compilation
    echo
    exit 0
fi

if [ x"${GvResult}" = x"${GvMenuUtilsContent[3]}" ]; then
    clear
    # Find the same level path which contains .git folder
    Lfn_Sys_GetSameLevelPath  GvBranchGitPath ".git"
    if [ ! -e "${GvBranchGitPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvBranchGitPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Path" 
        exit 0
    fi
    echo
    read -p "Ask @ run 'git clean -dfx;git reset --hard HEAD' if press [y]?    "  GvChoice
    echo
    if [ x"${GvChoice}" = x"y" ]; then
        cd ${GvBranchGitPath}
        git clean -dfx
        git reset --hard HEAD
        git status -s
        git log --graph \
            --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
            --abbrev-commit \
            --date=relative | head -n 4 
        cd - >/dev/null
        echo
    fi
    exit 0
fi

if [ x"${GvResult}" = x"${GvMenuUtilsContent[4]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    clear
    echo
    echo
    echo
    repo forall -c 'if [ x"$(git status -s)" != x ]; then echo;pwd;git status -s; fi' | tee All_Git_Repositories_Status.jll
    echo
    echo
    exit 0
fi


## "Sync Latest Code And Checkout Version Into TPM171E_R.0.xxx.yyy.zzz"
if [ x"${GvResult}" = x"${GvMenuUtilsContent[5]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt

    echo
    read -p "JLL-Ask: Sync Latest Code if press [y], or not:   "  GvChoice
    if [ x"${GvChoice}" = x"y" ]; then
        cd ${GvPrjRootPath}
        repo sync
        cd -  >/dev/null
    fi
    echo

    if [ ! -e "${GvPrjRootPath}/android/m-base/frameworks/.git" ]; then
        echo
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  \
            "JLL-Check @ Not Present \"${GvPrjRootPath}/android/m-base/frameworks/.git\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Path"
        echo
        exit 0
    fi
    clear
    cd ${GvPrjRootPath}/android/m-base/frameworks
    declare -i GvPageUnit=10
    declare -i GvMenuID=0
    declare -a GvPageMenuUtilsContent
    _GvVersionList=$(git tag -l TPM171E_R.0.*)
    if [ x"${_GvVersionList}" = x ]; then
        [ x"${GvPageUnit}" != x ] && unset GvPageUnit
        [ x"${GvMenuID}" != x ] && unset GvMenuID
        [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent
        echo
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  \
            "JLL-Check @ Not find any version like TPM171E_R.0.* format!!!" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Bye-Bye!!!"
        echo
        exit 0 
    fi
    for _GvVersionEntry in ${_GvVersionList}; do
        GvPageMenuUtilsContent[GvMenuID++]="${_GvVersionEntry}"
    done
    Fn_Sort_ThreeFields_SplitByDot "TPM171E_R" "Descend"
    Lfn_PageMenuUtils GvResult  "Select" 7 4 "***** WHICH VERSION TO CHECKOUT  (q: quit) *****"
    if [ x"${GvResult}" = x ]; then
        echo
        exit 0
    fi
    echo
    echo
    repo forall -c 'if [ x"$(git status -s)" != x ]; then \
                        read -p "Jll-Ask: Reset Code@ $(pwd) if press [y], or not:  " __GvChoive; \
                    fi; \
                    if [ x"${__GvChoive}" = x"y" ]; then \
                        git clean -dfx; git reset --hard HEAD; \
                    fi; \
                    git checkout ${GvResult} ' | tee All_Git_Checkout_${GvResult}.jll
    echo
    echo
    exit 0
fi


unset GvMenuUtilsContent
unset GvMenuUtilsContentCnt
exit 0
 
