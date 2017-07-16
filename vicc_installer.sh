#!/bin/bash
# Copyright (c) 2016 - 2100     jielong.lin     All rights reserved.
#

#------------------------------
# Constant Variable Definition
#------------------------------
CvPathFileForScript="`which $0`"
CvScriptName="`basename  ${CvPathFileForScript}`"
CvScriptPath="`dirname   ${CvPathFileForScript}`"

if [ x"$CvScriptPath" = x"." ]; then
    CvScriptPath="`pwd`"
fi

#------------- Start Of UI Library ---------------

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



## Lfn_Cursor_EchoConfig [on|off] 
function Lfn_Cursor_EchoConfig()
{
    if [ -z "$1" ]; then
        exit 0
    fi
    if [ x"$1" = x"off" ]; then
        echo -e "${CvAccOff}\033[?25l${CvAccOff}"
    fi
    if [ x"$1" = x"on" ]; then
        echo -e "${CvAccOff}\033[?25h${CvAccOff}"
    fi
}

function Lfn_Cursor_Move()
{
    if [ -z "$1" -o -z "$2" ]; then
        
        echo "Sorry,Exit due to the invalid usage" 
        exit 0
    fi

    echo $1 | grep -E '[^0-9]' >/dev/null && LvCmFlag="0" || LvCmFlag="1";
    if [ x"${LvCmFlag}" = x"0" ]; then
        
        echo "Sorry,Return because the parameter1 isn't digit" 
        return; 
    fi

    echo $2 | grep -E '[^0-9]' >/dev/null && LvCmFlag="0" || LvCmFlag="1";
    if [ x"${LvCmFlag}" = x"0" ]; then
        
        echo "Sorry,Return because the parameter2 isn't digit" 
        return; 
    fi

    #'\c' or '-n' - dont break line
    LvCmTargetLocation="${CvAccOff}\033[$2;$1H${CvAccOff}"
    echo -ne "${LvCmTargetLocation}"
}


function Lfn_Stdin_Read()
{
    if [ -z "$1" ]; then
        echo "Sorry, Exit due to the bad usage"
        
        exit 0
    fi

    LvSrData=""

    # Read one byte from stdin
    trap : 2   # enable to capture the signal from keyboard input ctrl_c
    while read -s -n 1 LvSrData
    do
        case "${LvSrData}" in
        "")
            read -s -n 1 -t 1 LvSrData
            case "${LvSrData}" in
            "[")
                read -s -n 1 -t 1 LvSrData
                case "${LvSrData}" in
                "A")
                    LvSrData="KeyUp"
                ;;
                "B")
                    LvSrData="KeyDown"
                ;;
                "C") 
                    LvSrData="KeyRight"
                ;;
                "D")
                    LvSrData="KeyLeft"
                ;;
                *)
                    echo "Dont Recognize KeyCode: ${LvSrData}"
                    continue;
                ;;
                esac 
            ;;
            "")
                LvSrData="KeyEsc"
            ;;
            *)
                echo "Dont Recognize KeyCode: ${LvSrData}"
                continue;
            ;;
            esac
        ;;
        "")
            # Space Key and Enter Key arent recognized
            LvSrData="KeySpaceOrEnter"
            break;
        ;;
        *)
            break;
        ;;
        esac
        [ ! -z "${LvSrData}" ] && break;
    done
    trap "" 2  # disable to capture the singal from keyboard input ctrl_c
    eval $1="${LvSrData}"
}



##
##    declare -a GvMenuUtilsContent=(
##        "userdebug: It will enable the most debugging features for tracing the platform."
##        "user:      It is offically release, and it only disable debugging features."
##    )
##    Lfn_MenuUtils LvpcResult  "Select" 7 4 "***** PhilipsTV Product Type (q: quit) *****"
##    if [ x"${LvpcResult}" = x"${GvMenuUtilsContent[0]}" ]; then
##        LvpcOptionBuild=userdebug
##        echo "hit"
##    fi
##
function Lfn_MenuUtils()
{
    if [ $# -gt 5 ]; then
        exit 0
    fi

    # Check if parameter is digit and Converse it to a valid parameter
    echo "$3" | grep -E '[^0-9]' >/dev/null && LvVisuX="0" || LvVisuX="$3";
    if [ x"${LvVisuX}" = x"0" ]; then
        LvVisuX=1
    fi
    echo "$4" | grep -E '[^0-9]' >/dev/null && LvVisuY="0" || LvVisuY="$4";
    if [ x"${LvVisuY}" = x"0" ]; then
        LvVisuY=1
    fi

    # Check if parameter is a valid
    if [ x"$2" != x"Input" -a x"$2" != x"Select" ]; then
        exit 0
    fi

    #LvVisuCount=$[${#GvMenuUtilsContent[@]} / 2]
    LvVisuCount=$(( ${#GvMenuUtilsContent[@]} / 1 ))
    if [ x"$2" = x"Select" -a ${LvVisuCount} -lt 1 ]; then
        # Select Mode but none item to be selected
        echo "Sorry, Cant Run Select Mode Because of None items to be selected."
        return
    fi

    # Select for configuration guide
    LvVisuFocus=99999 #None Focus
    LvVisuNextFocus=0

    while [ 1 ]; do
        ##
        ## Render UI
        ##
        if [ x"$2" = x"Select" ]; then # Input Mode
            Lfn_Cursor_EchoConfig "off"
        fi
        clear
        LvRenderLine=${LvVisuY}
        if [ x"$5" != x ]; then # exist title
            Lfn_Cursor_Move ${LvVisuX} ${LvRenderLine}
            echo "$5"
            LvRenderLine=$(( LvRenderLine + 1 ))
        fi
        if [ ${LvVisuCount} -gt 0 ]; then
            for (( LvVisuIdx=0 ; LvVisuIdx<LvVisuCount ; LvVisuIdx++ )) do
                if [ x"$2" = x"Select" ]; then
                    Lfn_Cursor_Move ${LvVisuX} ${LvRenderLine}
                    if [ ${LvVisuFocus} -eq ${LvVisuIdx} ]; then
                        if [ ${LvVisuFocus} -ne ${LvVisuNextFocus} ]; then
                            # Cancel the focus item reversed style
                            echo -ne "├── ${GvMenuUtilsContent[LvVisuIdx]}"
                            LvVisuFocus=99999 # lose the focus
                        else
                            # When Focus is the same to Next Focus, such as only exist one item
                            # Echo By Reversing its color
                            echo -ne "├── ${CvAccOff}\033[07m${GvMenuUtilsContent[LvVisuIdx]}${CvAccOff}"
                            LvVisuFocus=${LvVisuNextFocus}
                        fi
                    else
                        if [ ${LvVisuNextFocus} -eq ${LvVisuIdx} ]; then
                            # Echo By Reversing its color
                            echo -ne "├── ${CvAccOff}\033[07m${GvMenuUtilsContent[LvVisuIdx]}${CvAccOff}"
                            LvVisuFocus=${LvVisuNextFocus}
                        else
                            echo -ne "├── ${GvMenuUtilsContent[LvVisuIdx]}"
                        fi
                    fi
                    LvRenderLine=$(( LvRenderLine + 1 ))
                fi
                if [ x"$2" = x"Input" ]; then
                    Lfn_Cursor_Move ${LvVisuX} ${LvRenderLine}
                    echo -ne "├── ${GvMenuUtilsContent[LvVisuIdx]}"
                    LvRenderLine=$(( LvRenderLine + 1 ))
                fi
            done
            ##
            ## Drive UI
            ##

            if [ x"$2" = x"Select" ]; then
                Lfn_Cursor_Move ${LvVisuX} "$(( LvRenderLine + 4 ))"
                # echo "Focus:${LvVisuFocus} NextFocus:${LvVisuNextFocus} Count:${LvVisuCount}"
                echo "Focus:${LvVisuFocus} Count:${LvVisuCount}"
                Lfn_Stdin_Read LvCustuiData
                case "${LvCustuiData}" in
                "KeyUp"|"k")
                    if [ ${LvVisuNextFocus} -eq 0 ]; then
                        LvVisuNextFocus=${LvVisuCount}
                    fi
                    LvVisuNextFocus=$(expr ${LvVisuNextFocus} - 1)
                ;;
                "KeyDown"|"j")
                    LvVisuNextFocus=$(expr ${LvVisuNextFocus} + 1)
                    if [ ${LvVisuNextFocus} -eq ${LvVisuCount} ]; then
                        LvVisuNextFocus=0
                    fi
                    ;;
                "KeySpaceOrEnter")
                    echo ""
                    LvVisuFocus=${LvVisuNextFocus}
                    Lfn_Cursor_EchoConfig "on"
                    break
                    ;;
                "q")
                    LvVisuFocus=99999
                    echo ""
                    echo "Exit: Quit due to your choice: q"
                    echo ""
                    Lfn_Cursor_EchoConfig "on"
                    exit 0
                    ;;
                *)
                    ;;
                esac
                Lfn_Cursor_EchoConfig "on"
            fi
            if [ x"$2" = x"Input" ]; then
                Lfn_Cursor_Move ${LvVisuX} "$(( LvRenderLine + 1 ))"
                echo "[Please Input A String (Dont repeat name with the above)]"
                Lfn_Cursor_Move ${LvVisuX} "$(( LvRenderLine + 2 ))"
                read LvVisuData
                if [ -z "${LvVisuData}" ]; then
                    echo ""
                    continue
                fi
                if [ x"${LvVisuData}" = x"q" ]; then
                    echo ""
                    echo "Exit: due to your choice: q"
                    echo ""
                    exit 0
                fi
                LvVisuIsLoop=0
                if [ ${LvVisuCount} -gt 0 ]; then
                    for (( LvVisuIdx=0 ; LvVisuIdx<LvVisuCount ; LvVisuIdx++ )) do
                        if [ x"${GvMenuUtilsContent[LvVisuIdx]}" = x"${LvVisuData}" ]; then
                            LvVisuIsLoop=1
                            echo "Sorry, Dont repeat to name the above Items:\"${LvVisuData}\""
                            echo ""
                            break
                        fi
                    done
                fi
                if [ x"${LvVisuIsLoop}" = x"0" -a x"${LvVisuData}" != x ]; then
                    eval $1=$(echo -e "${LvVisuData}" | sed "s:\ :\\\\ :g")
                    unset LvVisuData
                    unset LvVisuIdx
                    unset LvVisuIsLoop
                    break
                fi
            fi
        else
            if [ x"$2" = x"Select" ]; then
                eval $1=""
                return
            fi
            if [ x"$2" = x"Input" ]; then
                Lfn_Cursor_Move ${LvVisuX} "$(( LvRenderLine + 1 ))"
                echo "[Please Input A String (Dont repeat name with the above)]"
                Lfn_Cursor_Move ${LvVisuX} "$(( LvRenderLine + 2 ))"
                read LvVisuData
                echo ""
                if [ x"${LvVisuData}" != x ]; then
                    eval $1="${LvVisuData}"
                    break
                fi
                if [ x"${LvVisuData}" = x"q" ]; then
                    echo "Exit: due to your choice: q"
                    echo ""
                    break
                fi
            fi
        fi
    done

    if [ x"$2" = x"Select" ]; then
        if [ ${LvVisuFocus} -ge 0 -a ${LvVisuFocus} -lt ${LvVisuCount} ]; then
            echo ""
            eval $1=$(echo -e "${GvMenuUtilsContent[LvVisuFocus]}" | sed "s:\ :\\\\ :g")
        fi
    fi

    unset LvVisuNextFocus
    unset LvVisuFocus
    unset LvVisuCount
}


##
##  declare -i GvPageUnit=10
##  declare -a GvPageMenuUtilsContent=(
##        "userdebug: It will enable the most debugging features for tracing the platform."
##        "user1:      It is offically release, and it only disable debugging features."
##        "user2:      It is offically release, and it only disable debugging features."
##        "user3:      It is offically release, and it only disable debugging features."
##        "user4:      It is offically release, and it only disable debugging features."
##        "user5:      It is offically release, and it only disable debugging features."
##        "user6:      It is offically release, and it only disable debugging features."
##        "user7:      It is offically release, and it only disable debugging features."
##        "user8:      It is offically release, and it only disable debugging features."
##        "user9:      It is offically release, and it only disable debugging features."
##  )
##  Lfn_PageMenuUtils LvpcResult  "Select" 7 4 "***** PhilipsTV Product Type (q: quit) *****"
##  if [ x"${LvpcResult}" = x"${GvPageMenuUtilsContent[0]}" ]; then
##      LvpcOptionBuild=userdebug
##      echo "hit"
##  fi
##
function Lfn_PageMenuUtils()
{
    if [ $# -gt 5 ]; then
        exit 0
    fi

    # Check if parameter is digit and Converse it to a valid parameter
    echo "$3" | grep -E '[^0-9]' >/dev/null && LvPmuX="0" || LvPmuX="$3";
    if [ x"${LvPmuX}" = x"0" ]; then
        LvPmuX=1
    fi
    echo "$4" | grep -E '[^0-9]' >/dev/null && LvPmuY="0" || LvPmuY="$4";
    if [ x"${LvPmuY}" = x"0" ]; then
        LvPmuY=1
    fi

    # Check if parameter is a valid
    if [ x"$2" != x"Input" -a x"$2" != x"Select" ]; then
        exit 0
    fi

    LvPageMenuUtilsContentCount=${#GvPageMenuUtilsContent[@]}
    LvPageIdx=0
    LvPageCount=$((LvPageMenuUtilsContentCount/GvPageUnit)) 
    while [ ${LvPageMenuUtilsContentCount} -gt 0 ]; do
        # Loading the specified page to display
        declare -a GvMenuUtilsContent
        for(( LvIdx=$((GvPageUnit*LvPageIdx)); LvIdx < LvPageMenuUtilsContentCount; LvIdx++ )) {
            if [ ${LvIdx} -lt $((GvPageUnit*LvPageIdx+GvPageUnit)) ]; then
                GvMenuUtilsContent[LvIdx-$((GvPageUnit*LvPageIdx))]="${GvPageMenuUtilsContent[${LvIdx}]}"
            else
                break
            fi
        }
        if [ ${LvIdx} -ne ${LvPageMenuUtilsContentCount} ]; then
            GvMenuUtilsContent[LvIdx-$((GvPageUnit*LvPageIdx))]="NextPage.$((LvPageIdx+1))"
        fi
        Lfn_MenuUtils LvResult  "$2" $3 $4 "$5"
        unset GvMenuUtilsContent
        if [ x"${LvResult}" = x"NextPage.$((LvPageIdx+1))" ]; then
            LvPageIdx=$((LvPageIdx+1))
            continue
        fi
        break
    done
    eval $1=$(echo -e "${LvResult}" | sed "s:\ :\\\\ :g")
}


## Lfn_Stdin_GetDigit <oResult> [<prompt>]
##
## Lfn_Stdin_GetDigit  oResult  "hello world: "
## echo "Result: $oResult"
function Lfn_Stdin_GetDigit()
{
    if [ ! -z "$2" ]; then 
        LvSgdCmd='read -p "$2 " LvSgdNum'
    else 
        LvSgdCmd='read LvSgdNum'
    fi   

    LvSgdNum=""
    while [ -z "${LvSgdNum}" ]; do
        eval ${LvSgdCmd}   
        echo ${LvSgdNum} | grep -E '[^0-9]' >/dev/null && LvSgdNum="" || break; 
    done 

    eval $1="${LvSgdNum}"
}

#------------- End Of UI Library ---------------





#####
#####  MAIN
#####
#if [ x"$(which realpath)" = x ]; then
#    echo
#    echo "JLL.IDE: Please install \"realpath\" first"
#    echo
#    exit 0
#fi



    # Check private ssh key
    GvRescuePath=${HOME}/.ssh.for_____release.R$(date +%Y%m%d%H%M%S)
    if [ -e "${HOME}/.ssh" ]; then
        mv -vf ${HOME}/.ssh  ${GvRescuePath} 
    fi
    mkdir -pv ${HOME}/.ssh
cat >${HOME}/.ssh/id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAwKhONxlyhpScITU0vrFnWH/wMv6w4lLADmZOhsl+UVGnDrB9
83wiOJqA6ObodNiWT6DXL+hzg8QqLeqkqIWirrb+Yv0YJx/MoEX+KO2NGStNN42V
+8HTrIo+FRe3Wo1xF4Jm+luwbJbWfy/qyRyEp0QWaanwg1NHx4e9Cx6Jrb7i7zsG
Ma+EPbwCln72G5pju5M/bFUqNT/TXL+E39C0lFvOXNzccFBrSmdEl2g1Zip7hycp
DpK8RFmFkDqE33TSFIGuJT583A9uTRZ98jfvsdpdXl3VvcpO0SDThUp/eIDNwABr
Wq8hDWPilNFt8NaX0Hh5xdDYL8yuGs2Pdn7yHwIDAQABAoIBABdOROf1dB1DrP93
aEIJQ+84yt3gYZV/XSxgw+8aQOWlcwgb4aCqy5j9V8rU5Bn+eXB4jI+HFzJBcLjN
Qc4BHIT2Lh/bbiiNeDuLPAvHcOIyksy9m/8wm2Kr9oamr8+MfLnTVJHEtbrtJFWO
fmCFyqZRXkS6AhZg5LYGfZ/yucUCtMHHv1vTvpG3aiE94Rj3bvpQ0aI392ZlrqtH
7fZgLuoDRcWsgwL7gApUpZmcJStb+AwfIyvE99FdeEAyUEAwCnJIxcdt4ey0iwqm
Nsd//iNRH8A9rs4cK4CirzqSD63+z2Rzr2AP7C5SBYKqDd/hsFk5gljESrzpwfaR
J2hdB4ECgYEA46PKha7U0cGLMATv45ocFN5acLWT9BXPMRa69p2hmzBdnpozLrbo
bXDq0nf+wHtVd3Q3Yeup2BilKIEKmuxfOUjjxN5Tn9OGVGQf02CdJCJi+Nj8QChz
f1oGzeqth6vpHpwg7D+WvPmLDKZAO8pwJP4Vgh9D2Bc/dMoxTNunV/cCgYEA2KjO
wPoZpq8lVQBhRfMjo0eoiN46DiKiU7YtEpNbnltlyCQ8YpFp9elZ1R4QX8Ar9h8a
rsKMz9Eevb+KUCpbQnCVIEsw02RKViA0XByfhXKOzRk51URjKG6irh7Vd+0wsmSc
+8F6rPtdO4+EhUSjZ+DK9P5s2tuzO+M9APD6vRkCgYEAxtIP2KLSjkGU5+PoAcpg
LHnoU/jDuLQzupQ3x531wC2GFzhm664lYzD0Z88WWdde1m5S0NucBHnCBpZuRNGe
edIH3bKxJy8AbETm5x/DIARInUAnUYIDHn/q4X7PAWhMu8dxmeYQKg1qPSoXgCFX
wXeKIZRdFSd47PCMDqzqhBECgYBnzWDZdjnp8UoakocIQ3hUl1V41bfM4+0P3F11
4+HmWfXG0Q2ZUAALUJS4laHUrjahwb8/8XgTbSakVGuJAvIcP+JCyaOH9CnlX6KW
ayRGhF9Ehox90DkNuwv4Dk/KGHrXTXsk50rGK9w8WANu8jaz4zB59pfit5YE4Fdu
5wXKqQKBgDiTR5gV1OkYOXnxyiO1s3vve7DWHzwrhFkcJ/qY1yOlxScxHa0Q7Lni
0oze4/lQ/9Jr2JZFcE0+SfWa1EdBFAnwVX0//eqFNNBaPz3GbZ4r5NwYr+kHH/vK
eyHGtGQh0XNVfafkHIWBuCAihK4e2TwX+xUDuzxOiHvH8Q7rhtg4
-----END RSA PRIVATE KEY-----
EOF
    chmod 0500 ${HOME}/.ssh/id_rsa

    GvReleasePath="R$(date +%Y%m%d_%H%M%S)"
    GvReleasePath="${HOME}/________release_${GvReleasePath}"
    if [ -e ${GvReleasePath} ]; then
        rm -rvf ${GvReleasePath}
    fi
    mkdir -pv ${GvReleasePath}

    cd ${GvReleasePath}
    #git clone git@code.csdn.net:qq1624646454/vicc.git
    git clone git@github.com:qq1624646454/vicc.git
    cd - 2>/dev/null


    if [ ! -e "${GvReleasePath}/vicc" ]; then
        #echo "JLL-IDE: Fail to install because git clone git@code.csdn.net:qq1624646454/vicc.git"
        echo "JLL-IDE: Fail to install because git clone git@github.com:qq1624646454/vicc.git"
    else
        cd ${GvReleasePath}/vicc
        # Update the release note for vicc_installer
        if [ -e "${GvReleasePath}/vicc/release" ]; then
            cp -rvf ${GvReleasePath}/vicc/release ${CvScriptPath} 
        fi
        #if [ -e "${GvReleasePath}/vicc/install.sh" ]; then
        if [ -e "${GvReleasePath}/vicc/install_with_sync.sh" ]; then
            cd ${GvReleasePath}/vicc
            #./install.sh
            ./install_with_sync.sh
            cd - >/dev/null
            echo
            echo "JLL-IDE: OKay for install vicc from ${GvReleasePath}/vicc"
            echo
        else
            echo
            echo "JLL-IDE: Failure for install vicc from ${GvReleasePath}/vicc"
            echo
        fi
    fi
    echo
#    [ -e "${GvReleasePath}" ] && rm -rf ${GvReleasePath}
    if [ -e "${HOME}/.ssh" -a -e "${GvRescuePath}" ]; then
        rm -rf ${HOME}/.ssh
        mv -f ${GvRescuePath} ${HOME}/.ssh
    fi
    unset GvRescuePath
    unset GvReleasePath
    echo
    echo "Exit 0"
    echo
    exit 0

