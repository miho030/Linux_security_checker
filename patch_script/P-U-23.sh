#!/bin/bash

# 목적 : U-22(상) cron 파일 소유자 및 권한 설정 조치 스크립트
# 내용 : cron 파일 소유자 및 권한 설정 여부 및 권고값 설정
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
cron_allow="/etc/cron.allow"
cron_deny="/etc/cron.deny"

# Global variable
AIO=`ls -l $cron_allow | awk '{print $3}'`
AIP=`ls -l $cron_allow | awk '{print $1}'`

PIO=`ls -l $cron_deny | awk '{print $3}'`
PIP=`ls -l $cron_deny | awk '{print $1}'`


#--------------------------------------------------------------------------------------
# check privelige
if [ "$EUID" -ne 0 ]; then 
	echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit 1
fi

#--------------------------------------------------------------------------------------
patch()
{

    #---------------------------------------------------------------------------------
	# check cron.allow file and check permision
	if [ -e $1 ]; then
		if [ $2 != root ]; then
            chown root $1
            return 0
        else
            return 0
        fi

        if [ $3 != -rw------- ]; then
            chmod 600 $2
            return 0
        else
            return 0
        fi
	else
        return 1
        exit 1
	fi

    #---------------------------------------------------------------------------------
    # check cron.allow file and check permision
	if [ -e $4 ]; then
		if [ $5 != root ]; then
            chown root $5
            return 0
		else
			return 0
		fi

        if [ $6 != -rw------- ]; then
            chmod 600 $6
            return 0
        else
            return 0
        fi
    else
        return 1
        exit 1
    fi
    #---------------------------------------------------------------------------------


}

#--------------------------------------------------------------------------------------
# final return
check()
{
    if [ -e $1 ] && [ -e $2 ]; then

        # check cron.allow file's permission and onwer
        if [ $3 = root ] && [ $4 = -rw------- ]; then
            return 0
        else
            return 1
        fi


        # check cron.deny file's permission and owner
        if [ $5 = root ] && [ $6 = -rw------- ]; then
            return 0
        else
            return 1
        fi

    else
        return 1
        exit 1
    fi 


}

# execute patch function and return retval
patch_retval=$(patch $cron_allow $AIO $AIP $cron_deny $PIO $PIP)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $cron_allow $cron_deny $AIO $AIP $PIO $PIP)

#--------------------------------------------------------------------------------------