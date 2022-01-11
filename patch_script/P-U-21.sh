#!/bin/bash

# 목적 : U-21(상) r 계열 서비스 비활성화 조치 스크립트
# 내용 : rlogin 서비스를 비활성화한다,
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
dst_file="/**/**"

# Global variable for this script
chk_comm="`systemctl list-units --type service --all | grep rlogin | awk '{print $3}'`"

# inetd, xinetd configuration file direction
conf1="/etc/inetd.conf"
conf2="/etc/xinetd.conf"

# r service setup file direction
rlogin="/etc/xinetd.d/rlogin"
rsh="/etc/xinetd.d/rsh"
rexec="/etc/ined.d/rexec"

#--------------------------------------------------------------------------------------
# check privelige
if [ "$EUID" -ne 0 ]; then 
	echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit 1
fi

#--------------------------------------------------------------------------------------
patch()
{

    #----------------------------------------------------------------------------------
	# check inetd.conf file and patch r login disable.
	if [ -e $1 ]; then

        # stop service
        inetadm –d rlogin
        inetadm –d rsh
        inetadm –d rexec

        return 0
        
	else
        echo "no found inetd.conf file"
        #-----------------------------------------------------------------------------
        # check xinetd.conf file and patch r login disable.
        if [ -e $2 ]; then
            # check rlogin
            if [ -e $3 ]; then
                sed -i 's/=yes/=no/g' $rlogin
                return 0
            fi

            # check rsh
            if [ -e $4 ]; then
                sed -i 's/=yes/=no/g' $rsh
                return 0
            fi

            # check rexec
            if [ -e $5 ]; then
                sed -i 's/=yes/=no/g' $rexec
                return 0
            fi
        #-----------------------------------------------------------------------------
        else
            echo "r servce status normal"
            return 1
        fi
	fi
    #----------------------------------------------------------------------------------

}

#--------------------------------------------------------------------------------------
# final return
check()
{

# check r service file and check setup value

    #----------------------------------------------------------------------------------
    # rlogin service
    if [ -e $1 ]; then
        if [ "`cat $1 | grep "disable" | awk '{print $3}'`" = no ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
    #----------------------------------------------------------------------------------
    # rsh service
    if [ -e $2 ]; then
        if [ "`cat $2 | grep "disable" | awk '{print $3}'`" = no ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
    #----------------------------------------------------------------------------------
    # rexec service
    if [ -e $3 ]; then
        if [ "`cat $3 | grep "disable" | awk '{print $3}'`" = no ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
    #----------------------------------------------------------------------------------

}

# execute patch function and return retval
patch_retval=$(patch $conf1 $conf2 $rlogin $rsh $rexec)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $rlogin $rsh $rexec)

#--------------------------------------------------------------------------------------