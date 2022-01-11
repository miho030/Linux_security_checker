#!/bin/bash

# 목적 : U-03(상) 계정 잠금 임계값 설정 조치 스크립트
# 내용 : 시스템 내 모든 계정을 대상으로 5번 이상 로그인 실패시 계정 잠금 임계값을 적용한다.
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung

ref="U-03.sh"
dst_file="/etc/pam.d/common-auth"

# check privelige
if [ "$EUID" -ne 0 ]; then
    echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit
fi


#--------------------------------------------------------------------------------------

# exist check common-password file
if [ -e $dst_file ]; then
    echo "*********************** 취약점 조치 시작 **************************"
    echo " "

    echo "  * 시스템 계정 잠금 임계값 설정 (로그인 5회 실패시 잠금)   >   완료"

    echo "#set login fail lock -> limit value = 5" >> $dst_file
    echo "auth required /lib/security/pam_tally.so deny=5 unlock_time=120 " >> $dst_file
    echo "no_magic_root" >> $dst_file
    echo "account required /lib/security/pam_tally.so no_magic_root reset" >> $dst_file

    echo " "
    echo "*********************** 취약점 조치 종료 **************************"

    exit 0
else
    echo "[WARN] 시스템 내에서  $dst_file  파일을 찾을 수 없습니다."
    exit 1
fi


#--------------------------------------------------------------------------------------