#!/bin/bash

# 목적 : U-24(상) NFS 서비스 비활성화 조치 스크립트
# 내용 : NFS 서비스 비활성화
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
src_file="/usr/sbin/rpc.nfsd"
dst_file="/usr/sbin/_rpc.nfsd"


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
	# check
    NC="`ps -ef | egrep "nfs|statd|lockd" | sed '$d' | grep -v kblock | grep -v grep`"
    if [ "$NC" != "" ]; then

        if [ -e $1 ]; then
            # kill nfs service in system.
            sudo service nfs-kernel-server stop

            # rename exec source file due to prevent restart itself.
            sudo mv $1 $2

            return 0
        else
            echo "[WARN] 시스템 내에서 ( $1 )  파일을 찾을 수 없습니다."
                return 1
            exit 1
        fi
    else
        echo "[WARN] 시스템 내에서 NFS가 설치되어 있지 않거나 비활성 상태입니다."
        return 1
    fi

    #---------------------------------------------------------------------------------


}

#--------------------------------------------------------------------------------------
# final return
check()
{
    if [ -e $2 ]; then
        return 0
    else
        return 1
    fi
}

# execute patch function and return retval
patch_retval=$(patch $src_file $dst_file)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $dst_file)

#--------------------------------------------------------------------------------------