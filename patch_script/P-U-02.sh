#!/bin/bash

# 목적 : 시스템 계정 패스워드 복잡성 설정(U-02) 조치 스크립트
# 내용 : 시스템 내 모든 계정을 대상으로 패스워드 복잡성 설정 여부 및 권고값 설정 여부를 확인하여
#       과학기술정보통신부, KISA의 보안가이드에 기재된 권고값으로 자동 변경한다.
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung

ref="U-02.sh"
dst_file="/etc/pam.d/common-password"

MINLEN=`cat $dst_file | grep -o -E "minlen=(-)?[0-9]*" |  awk -F= '{print $2}'`
LCREDIT=`cat $dst_file | grep -o -E "lcredit=(-)?[0-9]*" |  awk -F= '{print $2}'`
UCREDIT=`cat $dst_file | grep -o -E "ucredit=(-)?[0-9]*" |  awk -F= '{print $2}'`
DCREDIT=`cat $dst_file | grep -o -E "dcredit=(-)?[0-9]*" |  awk -F= '{print $2}'`
OCREDIT=`cat $dst_file | grep -o -E "ocredit=(-)?[0-9]*" |  awk -F= '{print $2}'`



# check privelige
if [ "$EUID" -ne 0 ]
	then echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit
fi

# exist check common-password file
if [ -e $dst_file ]; then


    if [ "least" = "`cat /etc/pam.d/common-password | grep digits | awk '{print $5}'`" ]; then
        exit 0

    else
        echo "*********************** 취약점 조치 시작 **************************"
        echo " "


        echo "  * 패스워드 복잡성 설정 #1 (최소 길이 8자 이상)       >   완료"
        echo " " >> $dst_file
        echo "# set password using least over 8 digits." >> $dst_file
        echo "minlen=8" >> $dst_file
    

        echo "  * 패스워드 복잡성 설정 #2 (최소 영소문자 1자 이상)   >   완료"
        echo "# set password including lowercase letters." >> $dst_file
        echo "lcredit=-1" >> $dst_file


        echo "  * 패스워드 복잡성 설정 #3 (최소 영대문자 1자 이상)   >   완료"
        echo "# set password including lowercase letters." >> $dst_file
        echo "ucredit=-1" >> $dst_file
    

        echo "  * 패스워드 복잡성 설정 #4 (최소 숫자 1자 이상)       >   완료"
        echo "# set password including lowercase letters." >> $dst_file
        echo "dcredit=-1" >> $dst_file
    

        echo "  * 패스워드 복잡성 설정 #5 (최소 특수문자 1자 이상)   >   완료"
        echo "# set password including lowercase letters.">> $dst_file
        echo "ocredit=-1" >> $dst_file
    

        echo " "
        echo "*********************** 취약점 조치 종료 **************************"
        exit 0
    fi

else    
    # is common-password file has not found.
    echo "[WARN] 시스템 내에서  $dst_file  파일을 찾을 수 없습니다."
fi