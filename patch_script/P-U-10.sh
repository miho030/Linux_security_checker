#!/bin/bash

# 목적 : U-10(상) /etc/(x)inetd.conf 파일 소유자 및 권한 조치 스크립트
# 내용 : INET, XINET, DINET 파일의 소유자 및 권한 설정 여부 및 권고값 설정 여부를 확인하여
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
dst_file="/**/**"

# Global variable for this script
INET="/etc/inetd.conf"
XINET="/etc/xinetd"
DINET="/etc/xinetd.d"

#--------------------------------------------------------------------------------------
# check privelige
if [ "$EUID" -ne 0 ]
	then echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit 1
fi

#--------------------------------------------------------------------------------------
patch()
{

	#check dinet file permission and file owner
	if [ -e $1 ]; then
        # local variable for inet patch function.
        IO=`ls -l $1 | awk '{print $3}'`
        IP=`ls -l $1 | awk '{print $1}'`
        # this is for result
        inet_res=1

        # check the file onwer.
        if [ $IO = root ]; then
            $inet_res=0
            else
                # change file owner permission to 'root'.
                chown root $1
                $inet_res=0
        fi

        # check the file permission.
        if [ $IP = -rw------- ]; then
           $inet_res=0
            else
                # change file owner permission to 'root'
                chmod 600 $1
                $inet_res=0
        fi
    else
        echo "[WARN] 시스템 내에서 ( $1 )  파일을 찾을 수 없습니다."
    fi

#-----------------------------------------------------------------
	#check xinet file permission and file owner
	if [ -e $2 ]; then
        # local variable for inet patch function.
        IO=`ls -l $2 | awk '{print $3}'`
        IP=`ls -l $2 | awk '{print $1}'`
        # this is for result
        xinet_res=1

        # check the file onwer.
        if [ $IO = root ]; then
            xinet_res=0
            else
                # change file owner permission to 'root'.
                chown root $1
                $xinet_res=0
        fi

        # check the file permission.
        if [ $IP = -rw------- ]; then
            $xinet_res=0
            else
                # change file owner permission to 'root'
                chmod 600 $1
                $xinet_res=0
        fi
    else
        echo "[WARN] 시스템 내에서 ( $1 )  파일을 찾을 수 없습니다."
    fi
    
#-----------------------------------------------------------------
    #check dinet file permission and file owner
	if [ -e $3 ]; then
        # local variable for inet patch function.
        IO=`ls -l $3 | awk '{print $3}'`
        IP=`ls -l $3 | awk '{print $1}'`
        # this is for result
        dinet_res=1

        # check the file onwer.
        if [ $IO = root ]; then
            $dinet_res=0
            else
                # change file owner permission to 'root'.
                chown root $1
                $dinet_res=0
        fi

        # check the file permission.
        if [ $IP = -rw------- ]; then
            $dinet_res=0
            else
                # change file owner permission to 'root'
                chmod 600 $1
                $dinet_res=0
        fi


#-----------------------------------------------------------------
    if [ $inet_res = 0 ] && [ $xinet_res = 0] && [ $dinet_res = 0 ]; then
        return 0
    else
            return 1
    fi

else
    echo "[WARN] 시스템 내에서 ( $1 )  파일을 찾을 수 없습니다."
fi

}

#--------------------------------------------------------------------------------------
# final return
check()
{
    # define universal variable due to check ' actually patch() function has been execute. '
    mod="-rw-------"
    own="root"

    if [ -e $1 ] && [ -e $2 ] && [ -e $3 ]; then
        IO=`ls -al $1 | awk '{print $3}'`
        IP=`ls -al $1 | awk '{print $1}'`
        XO=`ls -al $2 | awk '{print $3}'`
        XP=`ls -al $2 | awk '{print $1}'`
        DO=`ls -al $3 | awk '{print $3}'`
        DP=`ls -al $3 | awk '{print $1}'`
    else
        return 1
    fi
    
    if [ $mod = IO ] && [ $mod = XO ] && [ $mod = DO ] && [ $own = IO ] && [ $own = XO ] && [ $own = DO ]; then
        return 0
    else
        return 1
    fi
}

# execute patch function and return retval
patch_retval=$(patch $INET $XINET $DINET)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $INET $XINET $DINET)

#--------------------------------------------------------------------------------------