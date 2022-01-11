#!/bin/bash

# 목적 : U-08(상) /etc/shadow 파일 소유자 및 권한 조치 스크립트
# 내용 : /etc/shadow 파일 소유자 및 권한 설정 여부 및 권고값 설정 여부를 확인하여
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
dst_file="/etc/shadow"

# Global variable for this script
SP=`ls -l /etc/shadow | awk {'print $1'}`
SO=`ls -l /etc/shadow | awk {'print $3'}`
SG=`ls -l /etc/shadow | awk {'print $4'}`

#--------------------------------------------------------------------------------------
# check privelige
if [ "$EUID" -ne 0 ]
	then echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit 1
fi

#--------------------------------------------------------------------------------------
patch()
{

# check existance of destination file for modification.
if [ -e $1 ]; then

        # change file permission to 644 for /etc/shadows
        chmod 400 $1
        # change owner permission & management group to 'root' for /etc/shadows
        chown root $1
        # change management group to 'root' for /etc/shadows
        chown :shadow $1
    
    return 0
else
    echo "[WARN] 시스템 내에서  $1  파일을 찾을 수 없습니다."
    return 0
    exit 1
fi


}

#--------------------------------------------------------------------------------------
# check patch result & make retval and return it.
check()
{
    if [ $SP = -r-------- ] && [ $SO = root ] && [ $SG = shadow ]; then
        return 0
    else
        return 1
    fi
}

# execute patch function and return retval
patch_retval=$(patch $dst_file)
# final return
double_check_retval=$(check $SP $SO)


exit $double_check_retval
#--------------------------------------------------------------------------------------