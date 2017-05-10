#!/bin/bash
# Copyright (c) 2016-2100,  jielong_lin,  All rights reserved.
#
JLLPATH="$(which $0)"
JLLPATH="$(dirname ${JLLPATH})"
source ${JLLPATH}/BashShellLibrary


#git push ssh://${GvCONF_HOST}/${LvProject} HEAD:refs/for/${LvCurrentRevision}
GvCONF_HOST=url-tpemaster

#User@${GvCONF_EmailSuffix}
GvCONF_EmailSuffix=tpv-tech.com



#The below variables are set by __SSHCONF_GetCommiter
GvCONF_Committer_Author=
GvCONF_Committer_Email=

function __SSHCONF_GetCommiter()
{
    #Example For:
    #------------------------------
    #Host url
    #HostName 172.20.30.2
    #User jielong.lin 
    #Port 29420
    #IdentityFile ~/.ssh/id_rsa
    if [ ! -e "${HOME}/.ssh/config" ]; then
        GvCONF_Committer_Author=$(git config --global user.name)
        GvCONF_Committer_Email=$(git config --global user.email)
        if [ x"${GvCONF_Committer_Author}" != x -a x"${GvCONF_Committer_Email}" != x ]; then
            echo
            echo "JLL: using origin 'git config --global user.name and user.email':"
            echo "-----------------------------------------------------------"
            echo "JLL: committer author = ${GvCONF_Committer_Author}" 
            echo "JLL: committer email = ${GvCONF_Committer_Email}"
            echo 
        else
            echo
            echo "JLL: failed to use origin 'git config --global user.name and user.email'"
            echo "JLL: please set git config for committer by manual"
            echo
        fi
    else
        declare -a __HOST_Table
        OldIFS=${IFS}
        IFS=$'\n'
        GvI=0
        for GvLine  in $(grep -n -E "^Host " ${HOME}/.ssh/config); do
            __HOST_Table[GvI++]=${GvLine} 
        done 
        IFS=${OldIFS}
        if [ ${GvI} -lt 1 ]; then
            echo
            echo "JLL: Sorry to exit due to none HOST in ${HOME}/.ssh/config"
            echo
            unset __HOST_Table
            exit 0
        fi
        declare -a GvHitHostTable
        declare -a GvHitUserTable
        IFS=$'\n'
        GvK=0
        for GvLine in $(grep --color -n -E "^User " ${HOME}/.ssh/config); do
            echo "JLL: Probing ${GvLine}"
            GvIdx=${GvLine%%:*}
            # Search the line number of the Host 
            for((GvJ=0; GvJ<GvI; GvJ++)) {
                GvIsMatch=0
                if [ ${GvIdx} -lt ${__HOST_Table[GvJ]%%:*} ]; then
                    GvIsMatch=1
                else 
                    # GvIdx belong to the tail item
                    if [ $((GvJ+1)) -eq ${GvI} ]; then
                       echo "JLL: reach to Tail Item"
                       GvIsMatch=1
                       GvJ=$((GvJ+1))
                    fi
                fi

                if [ ${GvIsMatch} -eq 1 ]; then
                    GvIsHit=0
                    for((GvN=0;GvN<GvK;GvN++)) {
                        # check if same
                        if [ x"${GvHitHostTable[GvN]}" = x"${__HOST_Table[GvJ-1]##*Host }" ]; then
                           GvIsHit=1;
                           break;
                        fi
                    }
                    if [ ${GvIsHit} -eq 0 ]; then
                        echo "JLL: Hit=${__HOST_Table[GvJ-1]##*Host }"
                        GvHitHostTable[GvK]=${__HOST_Table[GvJ-1]##*Host }
                        GvHitUserTable[GvK++]=${GvLine##*User }
                    fi
                    break;
                fi
            }
        done
        IFS=${OldIFS}
        unset __HOST_Table
        echo
        echo "======================================="
        echo "JLL: Hit-Total is $GvK"
        echo "======================================="
        echo

        for((i=0;i<${GvK};i++)) {
            echo "JLL: Check if \"$(echo ${GvHitHostTable[i]})\"==\"${GvCONF_HOST}\" "
            if [ x"$(echo ${GvHitHostTable[i]})" = x"${GvCONF_HOST}" ]; then
                GvCONF_Committer_Author=$(echo ${GvHitUserTable[i]})
                GvCONF_Committer_Email=${GvCONF_Committer_Author}@${GvCONF_EmailSuffix}
                break;
            fi
        }
        unset GvHitHostTable
        unset GvHitUserTable

        if [ x"${GvCONF_Committer_Author}" != x -a x"${GvCONF_Committer_Email}" != x ]; then
            echo
            echo "JLL: using ${HOME}/.ssh/config for setting committer:"
            echo "-----------------------------------------------------------"
            echo "JLL: committer author = ${GvCONF_Committer_Author}" 
            echo "JLL: committer email = ${GvCONF_Committer_Email}"
            echo 
        else
            echo
            echo "JLL: failed to use ${HOME}/.ssh/config for setting committer"
            echo "JLL: please set git config for committer by manual"
            echo
        fi
    fi
}


__ssh_package=.__ssh_R$(date +%Y_%m_%d__%H_%M_%S)
function __SSHCONF_Switching_Start__jielong()
{
    echo
    if [ -e "${HOME}/.ssh" ]; then
        echo "JLL: ~/.ssh will be moved to ${__ssh_package}"
        mv -fv ${HOME}/.ssh  ${HOME}/${__ssh_package}
        echo
    fi
    mkdir -pv ${HOME}/.ssh
    chmod 0777 ${HOME}/.ssh
    echo "JLL: Generate ~/.ssh/id_rsa belong to jielong.lin@tpv-tech.com"
cat >${HOME}/.ssh/id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA30E5aVhLJYIp3exNWMIjKFTKd25oOxdw25oBJE4bDxS5yCsE
IJOhNrlPGKzyo22q3tIpiuZg4Ld6l9n2BxNbSND2sezhr4TnikVPPgCZdcGmUGho
OGkVM2CqTiEL2kL9qDS9vEOxg818nHhbiVuF7MVO0eij/Yk17/b+iDgSsmHJ5zcw
DMdA4+jauXERyAzdfEzHbmmKbR6L2TIkMPqYFieFHpS7zGxssR0tPxqTKd7I9reI
2b8rK2yTwCRnaWKTuKP+uOfLYrg0fdx/N88/X8sC6Vfw/qnaoPXoahW1cWDXH1G9
K7Gn+mZxKqGSOZlybcPL+ZNknKZytkRZqc3WRQIDAQABAoIBAGZq9JyIPckSQoSl
cAJE5X4OD+fkRXq+US7dIqL2FeHAP049taIAN9f0AP4v8QvaNqYLwbUP5OeSJHJf
MkeisKDiBBoxsoMjtFixXR3zhnMICHUgwJcIVgqA0QAQlvBlBRrSPyyL3Xa6oOzj
JhMIYpLxHSyczgZ0mMLiC3iQSLt913rdehD1y6aseinLyUuwembvxMZw2FIrSqy9
pKi50Pp2dWQ3rq4M11K7GTe9wfqvIIWVVvnYlawV5SNLUXlK5G8LFS4N/tUN+nqk
MCS7ooeeBKn9/UDjg7l5gDX/VqsCLBvCEO9mg8VT+jkUpE3nbEgO6gBsZ70mBnY9
H1D/iu0CgYEA9y3Ve2bsdmUiDRiNdEOR2WiGtAQOdPeEW6cX/9ldwo+Dff9ZRjXO
eTRjcDHUKmaHGmrrqyZnARAWrWZ9aVIGrPFHFyRAf/oApfJQYDHRtQ285rzKD3FQ
4HIV3TtYfO7gf756xtyYXLSQvNaXEjTbYw+mlZTpBnXWKFnl7LwpwncCgYEA5zjT
BbbgiIjxN56S0Ri8MCWRgeTwdmSIgz/m6+k0YEGu+H8GKmDvSmb7w2nxVuL1FhKQ
BvQe8Kaxnsfu5xiKGNjJ2cSzlR86Bp3h+oVQun7fcAUf704B35DPu1nuM4IyN1zn
gllsbGN10Eg7ZdSiucWcYbsqLMCGvgH6dux5wCMCgYEA9w7v350bYqdpJo/Q61GS
WSzZ3tpjHNQ9jmJwYYEA7zQE6Q4uTDgBvTH45i5X811xUp1mGzaSJATRtdXIKlob
ZAbx2JaahY/7z+JoJg4FnqMxmas/h7nqbbx6UBs+MfmNmQFptJTPEXJFbQpMC52b
XuNIzR/+3j8vpDtezoWwc7cCgYBvszfeTtZxnxZItEZg1P40lDGS+rJfv3ljTn+T
//jZd2G7kkG8P0/aNZ3ybT+1pbaYjycc9Nntj9nGxvdWlLhCAJiipy/KHme9wo/k
onq5XYk7aH5g8OJeympQK8WzBHaV4D/G7MRAKFxF3l8zdmGWNSyy2eQp8mglandA
9ERs2QKBgQCoYfcDBFi+bnr0USxBO2ysXOhkkzLzigos7WEeW+R56zmgqGiiw/o7
vot6BuT0GQnWnhFGh/uEM5+b0Y4vfDKxDXXb4j5Cn6wSMC+Xyn/5XKTJAMleZZg9
M1KJDNJyY9xEVITOo4KFxVTdmPWeuW8x+KRgpOT3Ws1OzBoSZXBo0g==
-----END RSA PRIVATE KEY-----
EOF
    chmod 0400 ${HOME}/.ssh/id_rsa
cat >${HOME}/.ssh/config<<EOF

Host url
HostName 172.20.30.2
User jielong.lin 
Port 29420
IdentityFile ~/.ssh/id_rsa

Host url-tpemaster
HostName 172.16.112.71
User jielong.lin 
Port 29418
IdentityFile ~/.ssh/id_rsa

EOF
    chmod 0600 ${HOME}/.ssh/config
    echo
}

function __SSHCONF_Switching_Start__xianmei()
{
    echo
    if [ -e "${HOME}/.ssh" ]; then
        echo "JLL: ~/.ssh will be moved to ${__ssh_package}"
        mv -fv ${HOME}/.ssh  ${HOME}/${__ssh_package}
        echo
    fi
    mkdir -pv ${HOME}/.ssh
    chmod 0777 ${HOME}/.ssh
    echo "JLL: Generate ~/.ssh/id_rsa belong to xianmei.liao@tpv-tech.com"
cat >${HOME}/.ssh/id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAsnEL6lFcTgekhY/2GQ6zZ0wAcViolX1uvDlAX3cNvEvgE9mA
EUVLNS41nQWvZpo84NLzorTSGlddIT3MIY75yEP3QxEmQG/uCviB4LOXxgpbuDcf
gQHnkWIDqysYccilyUKbQrf9C4ifaGh8Vk520A6L7tN+ObhhoqlJftQteKl361TJ
NeLSZ8KByGIQMpj2ZjePEGrBjUaLPjZElXgsISTb80db53MvDcQXjbXEuquYfM6r
+IsX+nIBssXmY2Lo5iY+NBHgDgmp+oSp6AHBlR0XYD16bYB6k2ZvbyFSJ3smE8rG
eBNeyk4GjfGDl36iW4gC1Jc6XU01aejCfMyGNwIDAQABAoIBABY+Axc1BwVu7HH9
jNZ4v6ILli6Kt5DSrr/lfwGnTF4BMzAmN1Fvyr0ZQnONJtzqMtZvVREd6uZ/p0si
cdRpBveQiTyh4Zu8l/ZkHYRNvohf+CjRLisdeqjjh8OJPqXINeoNVF8PogoTAJO6
Gm2DoEm01npxgFVfh0QIR/H4LqbQe5pX/hVEkYvbMRN6MX6BLU8RpigMAP5HBw8V
zTgm1uW4yhjIclvQuCxRTn/IwFCpuv6bRTJp1jFYwWA0+6zvrCYK3pDSZuccGI5P
5nsa3lH0J9y7PX9K3ozxLhdY7Kbrs+dP7T1Cfzhkn4JhZ0ja0nPzAn72kQ/LI19q
woQjcFECgYEA4HqkfVCxNo3u2lNyG0pXmt0eGSZhqAerDBRS3XN+uwGvyOXkkMNd
dZmgp4NajwrR9Yejys248ZIYRbOrRI6N9u2DiRFDxaf4tGnUf8Mwia14mxQt29+8
DFGz8dTN2KIKqjMl97nzlts6/uLlPY72GinEDG1Gzn+i80pMKLYrH48CgYEAy39+
LHSDaCFBFqeCJjYb8iNgr023doYzwej12fTgjthUdQ8/yNhWqDdz+2XK7TBtsBvs
nf0Q/rpdGKH81VqCPdl0Js76HDtKOWYt9jdz0V9eu6J860in0vOUf8er8RyiURnH
OxJ+iDIkfP9ZkEPSSr9uFR2a8Tqje+y29UEx2tkCgYEAnHtB8Q1wC3yTdWRYFcgU
G6NqWNPVnaGCzg/Y2ACr5ka9uEjxtSxLGTB3um4pka9UP1lHh5czBkr2WphtmoPZ
WLmnSMRdPwrhpzpi5JE3Y7Imccx2T2C+oMPPsZPLzujekFjJbdAViyLWFFosvWXM
Dt7wiE0g39A/0mMHhhW/J+cCgYEAhBpPnixE4eQ0jLBRHN0jZxzwNt0MrDSShN7m
Oods/04QBa3QimFmX+0fraN3CGLX0etOv4D492Oj68m8iAQpaF0xub/DPXB/zqM2
Uw/Mb66poMTqsxKHX7ogPJMyW2NrO5qwavimi2OBrGNXkP92FHAQ1kRRwSd/2YLh
gnTAGIECgYAamsuvGd2CKVaHrt1GrrweNYciPDB4UNGx5baizfywHxfOcQNT6/u/
5KcK+gvtCp+tENrKtikD9e4V+n/e4GyArafv5KlHddHxjPZWFv6njAO13f6ZB0Q5
RG72swzCsdlr/uPfv/0eUDEXLPWEv5OeZ3vhvlDPYlxZ+97SHii9iA==
-----END RSA PRIVATE KEY-----
EOF
    chmod 0400 ${HOME}/.ssh/id_rsa
cat >${HOME}/.ssh/config<<EOF

Host url
HostName 172.20.30.2
User xianmei.liao
Port 29420
IdentityFile ~/.ssh/id_rsa

Host url-tpemaster
HostName 172.16.112.71
User xianmei.liao
Port 29418
IdentityFile ~/.ssh/id_rsa

EOF
    chmod 0600 ${HOME}/.ssh/config
    echo
}


function __SSHCONF_Switching_End()
{
    if [ -e "${HOME}/${__ssh_package}" ]; then
        if [ -e "${HOME}/.ssh" ]; then
            rm -rvf ${HOME}/.ssh
        fi
        mv -vf ${HOME}/${__ssh_package}  ${HOME}/.ssh
        echo "JLL: Finish restoring the original ssh configuration."
    else
        echo "JLL: Nothing to do for restoring the original ssh configuration."
    fi
}




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
        Lfn_Sys_DbgEcho "Checking @ Not Exist ' ${LvmvVariable} '"
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
        Lfn_Sys_DbgEcho "Checking @ Not Exist ' ${LvpvVariable} '"
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
            set_m
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
            set_m
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
            set_m
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
      set_m
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


function Fn_PhilipsTV_GitPushToMaster()
{
    #__SSHCONF_Switching_Start
    __SSHCONF_Switching_Start__jielong
    LvProject=$(repo info . | grep -E '^Project: ' | awk -F'Project: ' '{print $2}')
    LvCurrentRevision=$(repo info . | grep -E 'Current revision: ' | awk -F'Current revision: ' '{print $2}')

    if [ x"${LvProject}" = x -o x"${LvCurrentRevision}" = x ]; then
        echo "JLL: Sorry to exit because can't get the valid information by 'repo info .'"
        __SSHCONF_Switching_End
        exit 0
    fi

    __SSHCONF_GetCommiter

    git config --global user.name  ${GvCONF_Committer_Author} 
    git config --global user.email ${GvCONF_Committer_Email} 
    echo
    echo "JLL: cat ~/.ssh/config"
    cat ~/.ssh/config
    echo
    echo "JLL: cat ~/.ssh/id_rsa"
    cat ~/.ssh/id_rsa 
    echo
    echo "JLL:  git push ssh://${GvCONF_HOST}/${LvProject} HEAD:refs/for/${LvCurrentRevision}"
    git push ssh://${GvCONF_HOST}/${LvProject} HEAD:refs/for/${LvCurrentRevision}
    __SSHCONF_Switching_End
}




#
# Location the which project associated with PhilipsTV
#
GvRootPath=${HOME}
if [ ! -e "${GvRootPath}" ]; then
    Lfn_Sys_DbgEcho "Sorry, Exit due to dont exist user \"~\" path"
    exit 0
fi

# Find the same level path which contains .repo folder
#Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
#if [ ! -e "${GvPrjRootPath}" ]; then
#    Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
#    Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
#    exit 0
#fi
#echo
#GvRepoPath="${GvRootPath##${GvPrjRootPath}}"

declare -a GvMenuUtilsContent=(
    "Query: software version"
    "Query: mediatek version"
    "Compilation: make or make_clean"
    "Init: obtain source code"
    "Reset: remove code changes For current git branch"
    "Query: all git repositore status"
    "Checkout:  sync to latest code with aligning to TPM171E_R.0.xxx.yyy.zzz"
    "Push: git push the changes into Master"
)
Lfn_MenuUtils GvResult  "Select" 7 4 "***** MENU (q: quit no matter what) *****"
GvResultID=0

# Query: software version
if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
    if [ ! -e "${GvPrjRootPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
        exit 0
    fi
    echo
    GvRepoPath="${GvRootPath##${GvPrjRootPath}}"
    clear
    echo
    Fn_PhilipsTV_VersionInfo
    echo
    exit 0
fi

# Query: mediatek version
if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
    if [ ! -e "${GvPrjRootPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
        exit 0
    fi
    echo
    GvRepoPath="${GvRootPath##${GvPrjRootPath}}"
    clear
    echo
    Fn_Mediatek_VersionInfo
    echo
    exit 0
fi

# Compilation: make or make_clean
if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
    if [ ! -e "${GvPrjRootPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
        exit 0
    fi
    echo
    GvRepoPath="${GvRootPath##${GvPrjRootPath}}"
    clear
    echo
    Fn_PhilipsTV_Compilation
    echo
    exit 0
fi

# Init: obtain source code
if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    clear
    echo
    #__SSHCONF_Switching_Start
    __SSHCONF_Switching_Start__jielong
    echo
    mkdir -pv 2k16_mtk_archer_refdev
    cd 2k16_mtk_archer_refdev
    repo init -u ssh://url/tpv/platform/manifest -b 2k16_mtk_archer_refdev
    repo sync
    cd -
    echo
    __SSHCONF_Switching_End
    echo
    exit 0
fi

# Reset: remove code changes For current git branch
if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    clear
    Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
    if [ ! -e "${GvPrjRootPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
        exit 0
    fi
    echo
    GvRepoPath="${GvRootPath##${GvPrjRootPath}}"
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

# Query: all git repositore status
if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
    if [ ! -e "${GvPrjRootPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
        exit 0
    fi
    echo
    GvRepoPath="${GvRootPath##${GvPrjRootPath}}"
    clear
    echo
    echo
    echo
    repo forall -c 'if [ x"$(git status -s)" != x ]; then echo;pwd;git status -s; fi' | tee All_Git_Repositories_Status.jll
    echo
    echo
    exit 0
fi


# Checkout:  sync to latest code with aligning to TPM171E_R.0.xxx.yyy.zzz
if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
    if [ ! -e "${GvPrjRootPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
        exit 0
    fi
    echo
    GvRepoPath="${GvRootPath##${GvPrjRootPath}}"
    echo
    read -p "JLL-Ask: Sync Latest Code if press [y], or not:   "  GvChoice
    if [ x"${GvChoice}" = x"y" ]; then
        unset GvChoice
        declare -i GvPageUnit=10
        declare -i GvMenuID=0
        declare -a GvPageMenuUtilsContent
        GvPageMenuUtilsContent[GvMenuID++]="automatically sync with reset"
        GvPageMenuUtilsContent[GvMenuID++]="automatically sync without reset"
        GvPageMenuUtilsContent[GvMenuID++]="manually sync"
        Lfn_PageMenuUtils GvAutoChoice  "Select" 7 4 "***** SYNC MODE  (q: quit) *****"
        GvChoice=1
        if [ x"${GvAutoChoice}" = x"${GvPageMenuUtilsContent[0]}" ]; then
            GvChoice=0
        fi
        if [ x"${GvAutoChoice}" = x"${GvPageMenuUtilsContent[1]}" ]; then
            GvChoice=1
        fi
        if [ x"${GvAutoChoice}" = x"${GvPageMenuUtilsContent[2]}" ]; then
            GvChoice=2
        fi
        [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent
        [ x"${GvMenuID}" != x ] && unset GvMenuID
        [ x"${GvPageUnit}" != x ] && unset GvPageUnit
 
        echo
        cd ${GvPrjRootPath}
        pwd
        echo
        if [ x"${GvChoice}" = x"2" ]; then # manually sync 
            repo forall -c 'pwd;if [ x"$(git status -s)" != x ]; then \
                            read -p "Jll: Reset Code@ $(pwd) if press [y], or not:  " __GvChoive; \
                            fi; \
                            if [ x"${__GvChoive}" = x"y" ]; then \
                                git clean -dfx; git reset --hard HEAD; \
                            fi; '
            
            __SSHCONF_Switching_Start__jielong
            repo sync
            __SSHCONF_Switching_End
        else
            if [ x"${GvChoice}" = x"1" ]; then # automatically sync without reset
                __SSHCONF_Switching_Start__jielong
                repo sync
                __SSHCONF_Switching_End
        else
            else
                if [ x"${GvChoice}" = x"0" ]; then # automatically sync with reset
                    repo forall -c "pwd; git clean -dfx; git reset --hard HEAD"
                    __SSHCONF_Switching_Start__jielong
                    repo sync
                    __SSHCONF_Switching_End
                else
                    echo "JLL: Error because unknown sync mode {manually or automatically}"
                fi
            fi
        fi
        echo
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
    cd - >/dev/null
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
    [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent
    [ x"${GvMenuID}" != x ] && unset GvMenuID
    [ x"${GvPageUnit}" != x ] && unset GvPageUnit
    if [ x"${GvResult}" = x ]; then
        echo
        exit 0
    fi
    declare -i GvPageUnit=10
    declare -i GvMenuID=0
    declare -a GvPageMenuUtilsContent
    GvPageMenuUtilsContent[GvMenuID++]="automatically checkout with reset"
    GvPageMenuUtilsContent[GvMenuID++]="automatically checkout without reset"
    GvPageMenuUtilsContent[GvMenuID++]="manually checkout"
    Lfn_PageMenuUtils GvAutoChoice  "Select" 7 4 "***** CHECKOUT MODE  (q: quit) *****"
    GvChoice=1
    if [ x"${GvAutoChoice}" = x"${GvPageMenuUtilsContent[0]}" ]; then
        GvChoice=0
    fi
    if [ x"${GvAutoChoice}" = x"${GvPageMenuUtilsContent[1]}" ]; then
        GvChoice=1
    fi
    if [ x"${GvAutoChoice}" = x"${GvPageMenuUtilsContent[2]}" ]; then
        GvChoice=2
    fi
    [ x"${GvPageMenuUtilsContent}" != x ] && unset GvPageMenuUtilsContent
    [ x"${GvMenuID}" != x ] && unset GvMenuID
    [ x"${GvPageUnit}" != x ] && unset GvPageUnit
 
    echo
    echo "JLL: Start to git checkout ${GvResult} by ${GvAutoChoice}"
    echo
    cd ${GvPrjRootPath}
    pwd
    echo
    if [ x"${GvChoice}" = x"2" ]; then # manually checkout 
        repo forall -c 'pwd;if [ x"$(git status -s)" != x ]; then \
                        read -p "Jll: Reset Code@ $(pwd) if press [y], or not:  " __GvChoive; \
                        fi; \
                        if [ x"${__GvChoive}" = x"y" ]; then \
                            git clean -dfx; git reset --hard HEAD; \
                        fi; ' >&1 | tee All_Git_Checkout_${GvResult}.jll
        repo forall -c "git checkout ${GvResult}" >&1 | tee -a All_Git_Checkout_${GvResult}.jll
    else
        if [ x"${GvChoice}" = x"1" ]; then # automatically checkout without reset
            repo forall -c "pwd; git checkout ${GvResult}" >&1 \
                | tee All_Git_Checkout_${GvResult}.jll
        else
            if [ x"${GvChoice}" = x"0" ]; then # automatically checkout with reset
                repo forall -c \
                    "pwd; git clean -dfx; git reset --hard HEAD; git checkout ${GvResult}" \
                    >&1 | tee All_Git_Checkout_${GvResult}.jll
            else
                echo "JLL: Error because unknown checkout mode {manually or automatically}" \
                    | tee All_Git_Checkout_${GvResult}.jll
            fi
        fi
    fi
    echo
    cd - >/dev/null
    pwd
    echo
    echo "JLL: End to git checkout ${GvResult}"
    echo
    exit 0
fi

# Push: git push the changes into Master
if [ x"${GvResult}" = x"${GvMenuUtilsContent[GvResultID++]}" ]; then
    unset GvMenuUtilsContent
    unset GvMenuUtilsContentCnt
    Lfn_Sys_GetSameLevelPath  GvPrjRootPath ".repo"
    if [ ! -e "${GvPrjRootPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvPrjRootPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Root Path" 
        exit 0
    fi
    echo
    GvRepoPath="${GvRootPath##${GvPrjRootPath}}"
    echo
    Lfn_Sys_GetSameLevelPath  GvBranchGitPath ".git"
    if [ ! -e "${GvBranchGitPath}" ]; then
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Path=\"${GvBranchGitPath}\"" 
        Lfn_Sys_DbgColorEcho ${CvBgBlack} ${CvFgRed}  "Error-Exit: Cannot find Git Path" 
        exit 0
    fi
    cd ${GvBranchGitPath}
    if [ x"$(git status -s)" = x ]; then
        echo "JLL: no any new changes to push"
        echo
        unset GvBranchGitPath
        cd - >/dev/null
        exit 0
    fi
    echo
    git status -s
    read -p "JLL: RUN 'git add -A; git commit' IF press [y], or exit?   " GvChoice
    if [ x"${GvChoice}" = x"y" ]; then
        git add -A
        git commit
        Fn_PhilipsTV_GitPushToMaster
    fi
    cd - >/dev/null
    unset GvBranchGitPath
    echo
    exit 0
fi

unset GvMenuUtilsContent
unset GvMenuUtilsContentCnt
exit 0
 
