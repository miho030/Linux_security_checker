#!/bin/bash

# 목적 : U-11(상) /etc/syslog.conf 파일 소유자 및 권한 조치 스크립트
# 내용 : /etc/syslog.conf, rsyslog.conf 파일의 소유자 및 권한 설정 여부 및 권고값을 설정한다.
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
SYSLOG="/etc/syslog.conf"
RSYSLOG="/etc/rsyslog.conf"

# Global variable for this script


#--------------------------------------------------------------------------------------
# check privelige
if [ "$EUID" -ne 0 ]
	then echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit 1
fi

#--------------------------------------------------------------------------------------
patch()
{
    # this is for result
    retval=1


	#check dinet file permission and file owner
	if [ -e $1 ]; then

        # change file owner permission to 'root'.
        chown root $1
        # change file owner permission to 'root'
        chmod 600 $1
        syslog_res=0

    else
        echo "[WARN] 시스템 내에서 ( $1 )  파일을 찾을 수 없습니다."
        syslog_res=1
    fi

#-----------------------------------------------------------------
    #check dinet file permission and file owner
	if [ -e $2 ]; then

        # change file owner permission to 'root'.
        chown root $2
        # change file owner permission to 'root'
        chmod 600 $2
        rsyslog_res=0

    else
        echo "[WARN] 시스템 내에서 ( $2 )  파일을 찾을 수 없습니다."
        rsyslog_res=1
    fi
    
#-----------------------------------------------------------------
    if [ $syslog_res = 0 ] || [ $rsyslog_res = 0 ]; then
        retval=0
        if [ $syslog_res = 0 ] || [ $rsyslog_res = 0 ]; then
            return 0
        fi
        
    else
        return 1
    fi
}

#--------------------------------------------------------------------------------------
# final return
check()
{
    # result val

    # define universal variable due to check ' actually patch() function has been execute. '
    mod='-rw-------'
    own='root'

    if [ -e $1 ]; then
        SO=`ls -al $1 | awk '{print $1}'`
        SP=`ls -al $1 | awk '{print $3}'`
        
        if [ $mod = $SO ] && [ $own = $SP ]; then
            resval=0
        else
            resval=1
        fi
    fi

    if [ -e $2 ]; then
        RO=`ls -al $2 | awk '{print $1}'`
        RP=`ls -al $2 | awk '{print $3}'`

        if [ $mod = $RO ] && [ $own = $RP ]; then
            resval=0
        else
            resval=1
        fi
    fi


    # check and return
    if [ resval = 0 ]; then
        return 0
    else
        return 1
    fi

}

# execute patch function and return retval
patch_retval=$(patch $SYSLOG $RSYSLOG)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $SYSLOG $RSYSLOG)

exit $double_check_retval

#--------------------------------------------------------------------------------------