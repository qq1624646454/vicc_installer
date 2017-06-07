#!/bin/bash
# Copyright(c) 2016-2100.  jielong.lin.  All rights reserved.
#
#   FileName:     ._______auto_sync_by_GIT__in_crontab.sh
#   Author:       jielong.lin
#   Email:        493164984@qq.com
#   DateTime:     2017-05-11 14:34:27
#   ModifiedTime: 2017-06-07 21:38:27


__ssh_package=.__ssh_R$(/bin/date +%Y_%m_%d__%H_%M_%S)
function __SSHCONF_Switching_Start__qq1624646454()
{
    /bin/echo
    if [ -e "${HOME}/.ssh" ]; then
        /bin/echo "JLL: ~/.ssh will be moved to ${__ssh_package}"
        /bin/mv -fv ${HOME}/.ssh  ${HOME}/${__ssh_package}
        /bin/echo
    fi
    /bin/mkdir -pv ${HOME}/.ssh
    /bin/chmod 0777 ${HOME}/.ssh
    /bin/echo "JLL: Generate ~/.ssh/id_rsa belong to 1624646454@qq.com"
/bin/cat >${HOME}/.ssh/id_rsa <<EOF
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
    /bin/chmod 0400 ${HOME}/.ssh/id_rsa
/bin/cat >${HOME}/.ssh/known_hosts<<EOF
|1|1Y/WPGsOxdGjZcsgf+K3KYJmvh0=|Dj2FgNYwAZ7p+UvIBLtqsG8VWxo= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|7I2Vxr7lB5NqpJJEvft90NU9Fdw=|9KRufpFHCfl0a8DeD0Uh3mYZxmQ= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
|1|88YtZzm7/CF+ejT+G22YDmElVkM=|M1FIoZjcbz4F9JGE4m5fICSCdUE= ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNS5MbD5mkY14lfZAxKn1PmugpwjTyPNGGaYNC2O9tru0DpB72OFlJWoqHxWf5Bv8oDkcL8IR7XR39ZLIWweocE=
|1|T+/B4u3y7c+CmUM3Kl2yIPI6nb0=|h3ytijyzEXIScyX9fVvvLMozSMA= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
EOF
    /bin/chmod 0644 ${HOME}/.ssh/known_hosts
    /bin/echo
}

function __SSHCONF_Switching_End()
{
    if [ -e "${HOME}/${__ssh_package}" ]; then
        if [ -e "${HOME}/.ssh" ]; then
            /bin/rm -rvf ${HOME}/.ssh
        fi
        /bin/mv -vf ${HOME}/${__ssh_package}  ${HOME}/.ssh
        /bin/echo "JLL: Finish restoring the original ssh configuration."
    else
        /bin/echo "JLL: Nothing to do for restoring the original ssh configuration."
    fi
}

function __IsGIT()
{
    if [ $# -ne 1 ]; then
        echo
        echo "JLL: Exit due to function prototype error! - __IsGIT <parameter>"
        echo
        exit 0
    fi

    # Push  URL: https://github.com/qq1624646454/jllutils.git
    # Push  URL: git@github.com:qq1624646454/jllutils.git
    __RawCTX=$(git remote show origin | grep -E "^[ ]{0,}Push[ ]{1,}URL:[ ]{0,}https:")
    if [ x"${__RawCTX}" = x ]; then
        __RawCTX=$(git remote show origin | grep -E "^[ ]{0,}Push[ ]{1,}URL:[ ]{0,}git@")
        if [ x"${__RawCTX}" = x ]; then
            echo
            echo "JLL: Exit due to unknown scheme such as git@ or https://"
            echo
            exit 0 
        fi
        # start with git@
        eval $1=1
        return
    fi
    # start with https:// 
    eval $1=0
    return
}



JLLPATH="$(/usr/bin/which $0)"
JLLPATH="$(/usr/bin/dirname ${JLLPATH})"
JLLPATH=$(cd ${JLLPATH} >/dev/null;pwd)
JLLSELF="$(/usr/bin/basename ${JLLPATH})"
if [ x"${JLLSELF}" = x ]; then
    JLLSELF=$(/bin/pwd)
    JLLSELF="$(/usr/bin/basename ${JLLSELF})"
    [ x"${JLLSELF}" = x ] && JLLSELF=unknown
fi

#
# Check if remote repository is latest updated.
#
declare -a __lstCommittedIDs
declare -i __iCommittedIDs
w3m https://github.com/qq1624646454/vicc/commits/master > _vicc_commits_from_github.html
__CTXLine="$(cat _vicc_commits_from_github.html \
             | grep -n -A 1 -E '^[ \t]{0,}.*[ \t]{1,}committed[ \t]{1,}' --color=never)"
rm -rf _vicc_commits_from_github.html
OldIFS="${IFS}"
IFS=$'\n'
for __CTXLn in ${__CTXLine}; do
    __CTXL=$(echo "${__CTXLn}" | grep -E '^[0-9]{1,}-[ \t]{1,}[0-9a-fA-F]{7,}')
    if [ x"${__CTXL}" != x ]; then
        __lstCommittedIDs[__iCommittedIDs++]="${__CTXL##* }"
    fi
done
IFS="${OldIFS}"
[ x"${__CTXLine}" != x ] && unset __CTXLine
[ x"${__lstCommittedIDs}" != x ] && unset __lstCommittedIDs
[ x"${__iCommittedIDs}" != x ] && unset __iCommittedIDs




__DT=$(/bin/date +%Y-%m-%d_%H:%M:%S)

if [ ! -e "${JLLPATH}/.git" ]; then
    /bin/echo
    /bin/rm -rf ${HOME}/cron.*.log
    /bin/echo
    /bin/echo "JLL: Error because not present \"${JLLPATH}/.git\"" > ${HOME}/cron.${JLLSELF}@${__DT}.log 
    /bin/echo "JLL: FOR ${JLLSELF}" >> ${HOME}/cron.${JLLSELF}@${__DT}.log 
    /bin/echo
    /bin/exit 0
fi

__RemoteRepository=$(/usr/bin/git remote show origin | /bin/grep -E '^[ ]{0,}Push[ ]{1,}URL:')
__RemoteRepository=${__RemoteRepository#*:}
[ x"${__RemoteRepository}" = x ] && __RemoteRepository="remote.${JLLSELF}"

cd ${JLLPATH}
/bin/echo "synchronizing with ${__RemoteRepository} @${__DT}"        >  _______auto_sync_by_GIT__in_crontab.log
__GitCHANGE="$(/usr/bin/git status -s)"
if [ x"${__GitCHANGE}" != x ]; then
  __IsGIT __IsEnter
  if [ ${__IsEnter} -eq 1 ]; then
    /usr/bin/git status -s                                           >> _______auto_sync_by_GIT__in_crontab.log
    /usr/bin/git add    -A                                           >> _______auto_sync_by_GIT__in_crontab.log
    /usr/bin/git commit -m \
"
Changes as follows: 
${__GitCHANGE}
"    >> _______auto_sync_by_GIT__in_crontab.log
    /bin/echo                                                        >> _______auto_sync_by_GIT__in_crontab.log
    __SSHCONF_Switching_Start__qq1624646454
    /bin/echo "Push Changes to '${__RemoteRepository}' by git push"  >> _______auto_sync_by_GIT__in_crontab.log
    /usr/bin/git push                                                >> _______auto_sync_by_GIT__in_crontab.log
    __SSHCONF_Switching_End
    /usr/bin/git status -s                                           >> _______auto_sync_by_GIT__in_crontab.log
    /usr/bin/git log | /usr/bin/head -n 4                            >> _______auto_sync_by_GIT__in_crontab.log
    /bin/echo                                                        >> _______auto_sync_by_GIT__in_crontab.log
  fi
fi
/bin/echo                                                            >> _______auto_sync_by_GIT__in_crontab.log
/bin/echo "Pull Changes from '${__RemoteRepository}' by git pull "   >> _______auto_sync_by_GIT__in_crontab.log
/usr/bin/git pull -f -u origin master                                >> _______auto_sync_by_GIT__in_crontab.log
/usr/bin/git log | /usr/bin/head -n 4                                >> _______auto_sync_by_GIT__in_crontab.log
/bin/echo                                                            >> _______auto_sync_by_GIT__in_crontab.log
cd - >/dev/null

