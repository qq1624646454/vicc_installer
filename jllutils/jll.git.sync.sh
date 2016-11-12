#!/bin/bash
# Copyright(c) 2016-2100   jielong.lin   All rights reserved.
#

JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
source ${JLLPATH}/BashShellLibrary

Lfn_Sys_GetSameLevelPath  GvRootPath ".repo"
if [ ! -e "${GvRootPath}" ]; then
    Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvRootPath}\"" 
    Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
    exit 0
fi
echo "jielong.lin: Found Git Root Path is \"${GvRootPath}\"" 

cd ${GvRootPath}
pwd

echo
echo "** align the version with remote git reposity"
read -p "** Run \" repo forall -c 'git clean -dfx; git reset --hard HEAD' \" if press [y]    " YourChoice
if [ x"$YourChoice" = x"y" ]; then
    repo forall -c 'git clean -dfx; git reset --hard HEAD'
fi
echo ""

echo "** align the latest version with remote git reposity"
read -p "** Run \" repo sync \" if press [y]     " YourChoice
echo ""
if [ x"$YourChoice" = x"y" ]; then
    repo sync
fi


if [ x"$GvRootPath}" != x -a -e "${GvRootPath}/android/l-mr1-tv-dev-archer/device/tpv/${TARGET_PRODUCT}/system.prop" ]; then
    more ${GvRootPath}/android/l-mr1-tv-dev-archer/device/tpv/${TARGET_PRODUCT}/system.prop 
    exit 0
fi

echo
echo "--------- PhilipsTV Tag Version Example ---------"
echo "2k15 EU FHT Version (Asta L):     QM152E_R0.5.255.9"
echo "2k16 EU UPlus Version (Asta M):   QM16XE_U_R0.6.50.0"
echo
echo
echo "** switch the version to the specified version, such as QM16XE_U_R0.6.50.0 for Asta M Uplus EU. "
echo "** details reference to \"device/tpv/xxx/system.prop\""
read -n 1 -s -p "** Done by running such as \" repo forall -c 'git checkout QM16XE_U_R0.6.50.0' \" " 
echo 
echo 
#


#################################################################################

