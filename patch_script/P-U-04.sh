#!/bin/bash

# 목적 : U-04(상) 패스워드 파일 보호 조치 스크립트
# 내용 : 시스템 내 모든 계정을 대상으로 패스워드 복잡성 설정 여부 및 권고값 설정 여부를 확인하여
#        ref : 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung

ref="U-04.sh"
dst_file="/etc/passwd"

# check privelige
if [ "$EUID" -ne 0 ]
	then echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit
fi


#--------------------------------------------------------------------------------------

# exist check common-password file
if [ -e $dst_file ]; then
    if [ "`cat /etc/passwd | grep "root" | awk -F: '{print $2}' | sed -n '1p'`" = "o" ]; then
        echo "*********************** 취약점 조치 시작 **************************"
        echo " "

        echo "  * U-04(상) 패스워드 파일 보호 설정 (로그인 5회 실패시 잠금)   >   완료"
        comm=$(`sed -i 's/root:o:/root:x:/g' $dst_file`)

        echo " "
        echo "*********************** 취약점 조치 종료 **************************"

        exit 0
    fi
else
    echo "[WARN] 시스템 내에서  $dst_file  파일을 찾을 수 없습니다."
    exit 1
fi

#--------------------------------------------------------------------------------------