#!/bin/bash

# 목적 : U-22(상) cron 파일 소유자 및 권한 설정 조치 스크립트
# 내용 : /etc/passwd 파일의 소유자 및 권한 설정 여부 및 권고값 설정 여부를 확인하여
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
dst_file="/**/**"

# Global variable for this script
A="1"
B="2"
c="3"

#--------------------------------------------------------------------------------------
# check privelige
if [ "$EUID" -ne 0 ]; then 
	echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit 1
fi

#--------------------------------------------------------------------------------------
patch()
{

	# check existance of destination file for modification.
	if [ -e $1 ]; then
		if [ ]; then
						# 실질적인 취약점 조치 시작 지점
	
	
				    # 실질적인 취약점 조치 종료 지점
	
							return 0
		else
			echo "[INFO] 이미 시스템이 정책에 대한 권고값을 가지고 있습니다. "
			return 0
		fi
	else
	    echo "[WARN] 시스템 내에서 ( $1 )  파일을 찾을 수 없습니다."
			return 1
	    exit 1
	fi


}

#--------------------------------------------------------------------------------------
# final return
check()
{
    if [  ] && [  ] && [  ]; then
        return 0
    else
        return 1
    fi
}

# execute patch function and return retval
patch_retval=$(patch $A $B $C)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $A $B $C)

#--------------------------------------------------------------------------------------