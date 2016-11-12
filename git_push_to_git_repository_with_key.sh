#!/bin/bash
#Copyright(c) 2016-2100,  jielong_lin,  All rights reserved.
#

git config branch.master.remote origin
git config branch.master.merge refs/heads/master

git status -s
git add -A
git commit -m "Submit the CHANGES by $(basename $0) @$(date +%Y-%m-%d\ %H:%M:%S)"

#####
#####  MAIN
#####
if [ x"$(which realpath)" = x ]; then
    echo
    echo "JLL.IDE: Please install \"realpath\" first"
    echo
    exit 0
fi

    # Check private ssh key
    GvRescuePath=$(realpath ~)/.ssh.for_____release.R$(date +%Y%m%d%H%M%S)
    if [ -e "$(realpath ~)/.ssh" ]; then
        mv -f $(realpath ~)/.ssh  ${GvRescuePath}
    fi
    mkdir -p $(realpath ~)/.ssh
cat >$(realpath ~)/.ssh/id_rsa <<EOF
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
    chmod 0500 $(realpath ~)/.ssh/id_rsa


git push -f -u origin master
git log --graph \
        --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
        --abbrev-commit \
        --date=relative | head -n 8

    if [ -e "$(realpath ~)/.ssh" -a -e "${GvRescuePath}" ]; then
        rm -rf $(realpath ~)/.ssh
        mv -f ${GvRescuePath} $(realpath ~)/.ssh
    fi
    unset GvRescuePath
 
