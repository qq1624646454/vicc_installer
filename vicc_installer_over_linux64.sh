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

#####
#####  MAIN
#####
while [ 1 -eq 1 ]; do
    _DT="$(date +%Y%m%d%H%M)"
    _relPKG="${HOME}/.vicc/release_R${_DT}"
    if [ ! -e "${_relPKG}" ]; then
        mkdir -p ${_relPKG}
    fi
    cd ${_relPKG}
    echo -e \
        "JLL@Installer| ${Fgreen}git clone ${JLLCFG_gitURL}${AC} under ${Fgreen}${_relPKG}${AC}"
    git clone ${JLLCFG_gitURL}
    cd - >/dev/null
    _releasePKG="${_relPKG}/${JLLCFG_gitURL##*/}"
    echo "JLL@Installer| Probe.1 to finding if .git is under ${_releasePKG}"
    if [ ! -e "${_releasePKG}/.git" ]; then
        _releasePKG="${_releasePKG%\.git}"
        echo "JLL@Installer| Probe.2 to finding if .git is under ${_releasePKG}"
    fi
    if [ ! -e "${_releasePKG}/.git" ]; then
        echo "JLL@Installer| Not found the legal release package path from ${_releasePKG}"
        break
    fi
    echo "JLL@Installer| Obtained release package path=${_releasePKG}"
    if [ ! -e "${_releasePKG}/jllsystem/settings/installer_with_sync.sh" ]; then
        echo "JLL@Installer| not found ${_releasePKG}/jllsystem/settings/installer_with_sync.sh"
        break
    fi
    cd ${_releasePKG}/jllsystem/settings
    ./installer_with_sync.sh "install"
    cd - >/dev/null
    [ -e "${_releasePKG}/README" ] && cp -rf ${_releasePKG}/README ${selfPath} 
    break
done

[ x"${_releasePKG}" != x ]  && unset _releasePKG
[ x"${_relPKG}" != x ]  && unset _relPKG
[ x"${selfPath}" != x ]  && unset selfPath


