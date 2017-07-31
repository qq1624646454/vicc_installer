#!/bin/bash
# Copyright (c) 2016 - 2100     jielong.lin     All rights reserved.
#

JLLCFG_gitURL="https://github.com/qq1624646454/vicc_for_linux64.git"

selfPath=$(dirname $0)
if [ x"${selfPath}" = x ]; then
    selfPath=$(pwd)
else
    selfPath=$(cd ${selfPath}; pwd)
fi

relPKG="${HOME}/.vicc/${JLLCFG_gitURL##*/}"
if [ -e "${relPKG}" ]; then
    echo -e "JLL@Installer| [32mRemoving original vicc IDE under ${relPKG}[0m"
    [ -e "${relPKG}/jllsystem/settings/installer_with_sync.sh" ] && \
        ${relPKG}/jllsystem/settings/installer_with_sync.sh "uninstall"
    rm -rf ${relPKG}
fi
relPKG="${relPKG%\.git}"
if [ -e "${relPKG}" ]; then
    echo -e "JLL@Installer| [32mRemoving original vicc IDE under ${relPKG}[0m"
    [ -e "${relPKG}/jllsystem/settings/installer_with_sync.sh" ] && \
        ${relPKG}/jllsystem/settings/installer_with_sync.sh "uninstall"
    rm -rf ${relPKG}
fi

if [ ! -e "${HOME}/.vicc" ]; then
    echo -e "JLL@Installer| [32mCreating ${HOME}/.vicc[0m"
    mkdir -p ${HOME}/.vicc
fi

#####
#####  MAIN
#####
while [ 1 -eq 1 ]; do

    cd ${HOME}/.vicc
    echo -e "JLL@Installer| [32mgit clone ${JLLCFG_gitURL} under ${HOME}/.vicc[0m"
    git clone ${JLLCFG_gitURL}
    cd - >/dev/null

    relPKG="${HOME}/.vicc/${JLLCFG_gitURL##*/}/jllsystem/settings"
    echo "JLL@Installer| Probe.1 to finding if installer_with_sync.sh is under ${relPKG}"
    if [ -e "${relPKG}/installer_with_sync.sh" ]; then
        echo -e "JLL@Installer| [32mInstalling latest vicc IDE under ${relPKG}[0m"
        ${relPKG}/installer_with_sync.sh "install"
        break
    fi
    relPKG="${HOME}/.vicc/${JLLCFG_gitURL##*/}"
    relPKG="${relPKG%\.git}/jllsystem/settings"
    echo "JLL@Installer| Probe.2 to finding if installer_with_sync.sh is under ${relPKG}"
    if [ -e "${relPKG}/installer_with_sync.sh" ]; then
        echo -e "JLL@Installer| [32mInstalling latest vicc IDE under ${relPKG}[0m"
        ${relPKG}/installer_with_sync.sh "install"
        break
    fi
    break
done
[ -e "${relPKG}/README" ] && cp -rf ${relPKG}/README ${selfPath}

[ x"${relPKG}" != x ]  && unset relPKG
[ x"${selfPath}" != x ]  && unset selfPath
[ x"${JLLCFG_gitURL}" != x ]  && unset JLLCFG_gitURL 

