#!/bin/bash
# Copyright (c) 2016-2100,  jielong_lin,  All rights reserved.
#
JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
#source ${JLLPATH}/BashShellLibrary

### Color Echo Usage ###
# Lfn_Sys_ColorEcho ${CvFgRed} ${CvBgWhite} "hello"
# echo -e "hello \033[0m\033[31m\033[43mworld\033[0m"

case x"$1" in
x"push")
    if [ x"$(git status -s)" != x ]; then
        git add -A
        git commit -m "update by $(basename $0) @ $(date +%Y-%m-%d\ %H:%M:%S)"
    fi
    git push -u origin master
    git log --graph \
            --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
            --abbrev-commit \
            --date=relative | head -n 8
    echo
;;
x"pull")
    if [ x"$(git status -s)" != x ]; then
        read -p "JLL-GIT-REPO: Remove all Changes via 'git clean -dfx;git reset --hard HEAD' if press [y], or skip:   " GvChoice
        if [ x"${GvChoice}" = x"y" ]; then
            git clean -dfx;
            git reset --hard HEAD;
        fi
    fi
    git pull -u origin master
    git log --graph \
        --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
        --abbrev-commit \
        --date=relative | head -n 8
    echo
;;
*)
cat >&1 <<EOF

   USAGE:

     $(basename $0) [help]

     # If change is checked by 'git status -s', the follows will be run:
     # 'git add -A'
     # 'git commit -m "update by $(basename $0) @Date"'
     # 'git push -u origin master'
     $(basename $0) push

     # If change is checked by 'git status -s', the follows will be run: 
     # 'git clean -dfx;git reset --hard HEAD' if approve to cleanup all changes
     # 'git pull -u origin master' is always run
     $(basename $0) pull

EOF
;;
esac

exit 0

