#!/bin/bash

# 목적 : U-12(상) /etc/services  파일 소유자 및 권한 조치 스크립트
# 내용 : /etc/services 파일의 소유자 및 권한 설정 여부 및 권고값을 설정한다.
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
SERVICE="/etc/services"

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
    if [ -e $1 ]; then

        # change file permission to 600
        chmod 600 $1

        # change file owner to 'root'
        chown root $1

        return 0

    else
        echo "[WARN] 시스템 내에서 ( $2 )  파일을 찾을 수 없습니다."
        return 1
    fi
 

}

#--------------------------------------------------------------------------------------
# final return
check()
{
    # define universal variable due to check ' actually patch() function has been execute. '
    mod="-rw-------"
    own="root"

    if [ -e $1 ]; then
        IO=`ls -al $1 | awk '{print $1}'`
        IP=`ls -al $1 | awk '{print $3}'`
    
        if [ $IO = $mod ] && [ $IP = $own ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

# execute patch function and return retval
patch_retval=$(patch $SERVICE)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $SERVICE)

exit $double_check_retval

#--------------------------------------------------------------------------------------