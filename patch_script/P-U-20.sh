#!/bin/bash

# 목적 : U-20(상) Anonymous FTP 비활성화 조치 스크립트
# 내용 : vsftp, proftp 서비스 사용시 익명 권한 비활성화
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
dst_file="/**/**"
retval=1

# Global variable for this script
vsftp_dir1="/etc/vsftpd/vsftpd.conf"
vsftp_dir2="/etc/vsftpd.conf"

tmp="./vsftpd.conf"


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
    # patch vsftpd's /etc/vsftpd/vsftpd.conf.
    if [ -e $3 ]; then
        if [ "`cat $1 | grep anonymous_enable | awk -F= '{print $2}'`" = YES ]; then
            # 실질적인 취약점 조치 시작 지점
            echo "[dir1] proftpd patched"
            sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' $1
            # 실질적인 취약점 조치 종료 지점
            return 0
        fi
    else
        echo "[dir1] no file"
        return 1
    fi

    #----------------------------------------------------------------------------------
    # check vsftpd's /etc/vsftpd.conf.
    if [ -e $2 ]; then
        if [ "`cat $2 | grep anonymous_enable | awk -F= '{print $2}'`" = YES ]; then
            # 실질적인 취약점 조치 시작 지점
            echo "[dir2] proftpd patched"
            sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' $2
            # 실질적인 취약점 조치 종료 지점
            reutrn 0
        fi
    else
        echo "[dir2] no file"
        return 1
    fi

}

#--------------------------------------------------------------------------------------
# final return

# check each result due to know patch() actuall worked it self.
# check vsftpd setup value

check()
{
    if [ -e "/etc/vsftpd/vsftpd.conf" ]; then
        if [ "`cat $vsftp_dir1 | grep anonymous_enable | awk -F= '{print $2}'`" = NO ]; then
            return 0
        else
            return 1
        fi
    else
        if [ -e "/etc/vsftpd.conf" ]; then
            if [ "`cat /etc/vsftpd.conf | grep anonymous_enable | awk -F= '{print $2}'`" = NO ]; then
                return 0
            else
                return 1
            fi
        else
            return 1
        fi
    fi
}


# patch vsftpd, proftpd's anonymout access
patch $vsftp_dir1 $vsftp_dir2 

#--------------------------------------------------------------------------------------