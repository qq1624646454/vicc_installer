#!/bin/bash
# Copyright(c) 2016-2100.  jielong.lin    All rights reserved.
#
#

GvVersion="R2016.9.7.001  @ 2016 September 7"

function Lfn_Sys_GetEachUpperLevelPath()
{
    if [ -z "$1" ]; then
        echo "Error and Exit | Lfn_Sys_GetEachUpperLevelPath() - usage is incorrect "
        exit 0
    fi

    LvGadoulPaths=""
    LvGadoulPath=`pwd`
    while [ x"${LvGadoulPath}" != x -a x"${LvGadoulPath}" != x"/" ]; do
        if [ -z "${LvGadoulPaths}" ]; then
            LvGadoulPaths="${LvGadoulPath}"
        else
            LvGadoulPaths="${LvGadoulPaths}:${LvGadoulPath}"
        fi

        #LvGadoulBasename=`basename "${LvGadoulPath}"`
        #LvGadoulPath=`echo "${LvGadoulPath}" | sed "s/\/${LvGadoulBasename}//"`
        LvGadoulPath=`cd ${LvGadoulPath}/..;pwd`
    done

    LvGadoulPaths=`echo "${LvGadoulPaths}" | sed "s/\ /\\\\\ /g"`
    if [ -z "${LvGadoulPaths}" ]; then
        echo "Fail to find the required PATH and Exit"
        exit 0
    fi

    eval $1="${LvGadoulPaths}"
}

function Lfn_Sys_GetSameLevelPath()
{
    if [ $# -ne 2 -o -z "$2" ]; then
        echo "Error and Exit | Lfn_Sys_GetSameLevelPath() - usage is incorrect "
        exit 0
    fi

    LvSgslpKeywords="$2"
    eval $1=""

    # visit every location from the tails of the current path
    Lfn_Sys_GetEachUpperLevelPath LvSgslpPaths
    OldIFS=$IFS
    IFS=:
    for LvSgslpPath in ${LvSgslpPaths}; do
        IFS=$OldIFS
        echo
        echo "Matching:\"${LvSgslpKey}\""
        echo "  ├──SearchPath= \"${LvSgslpPath}\""
        for LvSgslpKey in ${LvSgslpKeywords}; do
            LvSgslpEntrys="$(ls -a ${LvSgslpPath})"
            for LvSgslpEntry in ${LvSgslpEntrys}; do
                if [ x"${LvSgslpEntry}" = x"${LvSgslpKey}" ]; then
        echo "  │  ├──Matching= \"${LvSgslpEntry}\" (Hit)"
                    LvSgslpPath=`echo "${LvSgslpPath}" | sed "s/\ /\\\\\ /g"`
                    eval $1="${LvSgslpPath}"
                    IFS=$OldIFS
        echo
        echo "Done-Success: \"${LvSgslpPath}\""
                    echo
                    return 0
                fi
        echo "  │  ├──Matching= \"${LvSgslpEntry}\""
            done
        done
        IFS=:
    done
    IFS=$OldIFS
    echo
    echo "Done-Failure: FinalPath=\"${LvSgslpPath}\""
    echo
    return 0
}


echo
if [ ! -e "$(pwd)/.settings.conf" ]; then
    echo
    echo "Sorry, Don't exist \"$(pwd)/.settings.conf\""
    echo
    echo
    echo "SOLVE it by do the follows:"
    echo "==========================="
    echo "user@linux:. # vim .settings.conf"
    echo "#!/bin/bash"
    echo "GvCONF_Project=/mnt/localdata/localhome/jielong.lin/workspace/aosp_6.0.1_r10_selinux"
    echo ""
    echo ":wq"
    echo "user@linux:. #"
    echo
    echo "OKay, Automatically generate .settings.conf Successfully"
    echo "Please customize your requirement in .settings.conf"
    echo
    echo "#!/bin/bash" > $(pwd)/.settings.conf
    echo "#Copyright(c) 2016-2100, jielong.lin, All rights reserved." >> $(pwd)/.settings.conf
    echo "#Automatically generate, Please customize your requirement" >> $(pwd)/.settings.conf
    echo >> $(pwd)/.settings.conf
    echo "GvCONF_Project=$(realpath ~)/workspace/aosp_6.0.1_r10_selinux" >> $(pwd)/.settings.conf
    echo >> $(pwd)/.settings.conf
    echo
    vim $(pwd)/.settings.conf
fi

source  $(pwd)/.settings.conf

if [ x"$GvCONF_Project}" = x ]; then
    echo
    echo "Sorry, GvCONF_Project isn't specified in .settings.conf"
    echo
    exit 0
fi

if [ x"$(pwd)" = x"${GvCONF_Project}" ]; then
    echo
    echo "Sorry, Current Path is treated as Patch Path"
    echo
    exit 0
fi

if [ ! -e "${GvCONF_Project}" ]; then
    echo
    echo "Sorry, Not exist GvCONF_Project=\"${GvCONF_Project}\" defined .settings.conf"
    echo
    exit 0
fi



GvOldPath=$(pwd)
cd ${GvCONF_Project}
#
# Find the same level path which contains .git folder
#

Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
if [ ! -e "${GvPrjRootPath}" ]; then
    echo "Path=\"${GvPrjRootPath}\"" 
    echo "Error-Exit: Cannot find Git Root Path" 
    exit 0
fi
echo

GvCONF_SourceFile="${GvPrjRootPath}/All_Git_Repositories_Status.jll"

if [ -e "${GvCONF_SourceFile}" ]; then
    read -p "Re-Build  \"${GvCONF_SourceFile##*/}\" if press [y], or Use original file:   " GvChoice
else
    GvChoice=y
fi
if [ x"${GvChoice}" = x"y" ]; then
    [ x"${GvCONF_Project}" != x"${GvPrjRootPath}" ] && cd ${GvPrjRootPath}
    repo forall -c 'if [ x"$(git status -s)" != x ]; then echo;pwd;git status -s; fi' | tee ${GvCONF_SourceFile}
    [ x"${GvCONF_Project}" != x"${GvPrjRootPath}" ] && cd -
fi
cd ${GvOldPath}
unset GvOldPath
unset GvPrjRootPath

read -p "Edit \"${GvCONF_SourceFile##*/}\" if press [y], or skip:   "  GvChoice
if [ x"${GvChoice}" = x"y" ]; then
    vim  ${GvCONF_SourceFile} 
fi

#
# Setup Source Pool , namely ${GvSourcePool}
#
#
    if [ ! -e "${GvCONF_SourceFile}" ]; then
        echo "Sorry, Don't exist \"${GvCONF_SourceFile}\""
        unset GvCONF_SourceFile
        unset GvCONF_Project 
        exit 0
    fi

    LvsspLineId=0
    LvsspPath=""
    declare -a GvSourcePool
    declare -i GvSourcePoolId=0
    while read LvsspLine; do
        ((LvsspLineId=LvsspLineId+1))
        if [ x"${LvsspLine}" = x ];then
            if [ x"${LvsspPath}" != x ]; then
                LvsspPath="" 
            fi
            continue
        fi
        if [ -d "${LvsspLine}" ]; then
            LvsspPath=${LvsspLine}
            continue
        fi
        for LvsspItem in ${LvsspLine}; do
            if [ -e "${LvsspPath}/${LvsspItem}" ]; then
                GvSourcePool[GvSourcePoolId]="${LvsspPath}/${LvsspItem}"
                GvSourcePoolId=$((GvSourcePoolId+1))
            fi
        done
    done < ${GvCONF_SourceFile} 

    unset LvsspLineId
    unset LvsspPath 
    if [ ${GvSourcePoolId} -lt 1 ]; then
        echo
        echo "Sorry,Don't exist any valid item @${GvCONF_SourceFile}" 
        echo
        rm -rf ${GvCONF_SourceFile}
        unset GvSourcePoolId
        unset GvSourcePool
        unset GvCONF_SourceFile
        unset GvCONF_Project 
        exit 0
    fi

    mv -fv ${GvCONF_SourceFile}  $(pwd)/

    echo "#!/bin/bash" > $(pwd)/jll.merge_to_project.sh
    echo "# Copyright(c) 2016-2100. jielong.lin.  All rights reserved."  >> $(pwd)/jll.merge_to_project.sh
    echo "# Autumatically Generated by $(basename $0)"  >> $(pwd)/jll.merge_to_project.sh
    echo >> $(pwd)/jll.merge_to_project.sh
    echo >> $(pwd)/jll.merge_to_project.sh
    echo "echo">> $(pwd)/jll.merge_to_project.sh
    echo "echo \"Copyright (c) 2016-2100.  jielong.lin.  All rights reserved.\" ">> $(pwd)/jll.merge_to_project.sh
    echo "echo \"Version: ${GvVersion}\""                                        >> $(pwd)/jll.merge_to_project.sh
    echo "echo \"Date: $(date +%Y-%m-%d\ %H:%M:%S)\""                            >> $(pwd)/jll.merge_to_project.sh
    echo                                                                         >> $(pwd)/jll.merge_to_project.sh
    echo "echo"                                                                  >> $(pwd)/jll.merge_to_project.sh
    echo "GvCONF_Proj=${GvCONF_Project}"                                   >> $(pwd)/jll.merge_to_project.sh
    echo "if [ ! -e \"\${GvCONF_Proj}\" ]; then"                           >> $(pwd)/jll.merge_to_project.sh
    echo "    echo \"JLL-Merge: Sorry, don't exist path=\${GvCONF_Proj}\"" >> $(pwd)/jll.merge_to_project.sh
    echo "    exit 0"                                                      >> $(pwd)/jll.merge_to_project.sh
    echo "fi"                                                              >> $(pwd)/jll.merge_to_project.sh
    echo "echo"                                                            >> $(pwd)/jll.merge_to_project.sh
    chmod +x $(pwd)/jll.merge_to_project.sh

    echo "## Changed File List ##" > $(pwd)/filelist.txt
    echo "repo forall -c 'if [ x\"\$(git status -s)\" != x ]; then echo;pwd;git status -s; fi'" >> $(pwd)/filelist.txt
    echo >> $(pwd)/filelist.txt
    echo >> $(pwd)/filelist.txt

    for(( i=0; i<$GvSourcePoolId; i++)) {
        #echo "$i: ${GvSourcePool[i]}"
        GvTargetFile=$(pwd)/${GvSourcePool[i]##*${GvCONF_Project}/}
        GvTargetPath=$(dirname ${GvTargetFile})
        if [ ! -e "${GvTargetPath}" ]; then
            mkdir -pv ${GvTargetPath}
        fi
        cp -rvf ${GvSourcePool[i]} ${GvTargetPath}
        echo                                           >> $(pwd)/filelist.txt
        echo "${GvSourcePool[i]##*${GvCONF_Project}/}" >> $(pwd)/filelist.txt
        echo                                           >> $(pwd)/jll.merge_to_project.sh
        echo "echo"                                                                  >> $(pwd)/jll.merge_to_project.sh
        echo "echo \"Do you want to Merge \\\"${GvSourcePool[i]##*${GvCONF_Project}/}\\\" ?\"" >> $(pwd)/jll.merge_to_project.sh
        echo "read -p \" [y]Merge,  [q]Quit,  [enter]Skip ?  YourChoice= \" YourChoice"        >> $(pwd)/jll.merge_to_project.sh
        echo "if [ x\"\${YourChoice}\" = x\"y\" ]; then"                             >> $(pwd)/jll.merge_to_project.sh
        echo "    vim -d \\"                                                         >> $(pwd)/jll.merge_to_project.sh
        echo "        \${GvCONF_Proj}/${GvSourcePool[i]##*${GvCONF_Project}/}  \\"   >> $(pwd)/jll.merge_to_project.sh
        echo "        ./${GvSourcePool[i]##*${GvCONF_Project}/}"                     >> $(pwd)/jll.merge_to_project.sh
        echo "else"                                                                  >> $(pwd)/jll.merge_to_project.sh
        echo "    [ x\"\${YourChoice}\" = x\"q\" ] && exit 0;"                       >> $(pwd)/jll.merge_to_project.sh
        echo "fi"                                                                    >> $(pwd)/jll.merge_to_project.sh
        echo "echo"                                                                  >> $(pwd)/jll.merge_to_project.sh
        echo >> $(pwd)/jll.merge_to_project.sh
    }

    unset GvSourcePoolId
    unset GvSourcePool
    unset GvCONF_SourceFile
    unset GvCONF_Project 
exit 0



