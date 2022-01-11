    #!/bin/bash

    # 목적 : U-26(상) automountd 제거 조치 스크립트
    # 내용 : automountd, autofs 서비스 비활성화
    #        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
    # Copyright 2021 all reserved Team Hurryup
    # Author : Lee Joon Sung


    #--------------------------------------------------------------------------------------
    # Universal variable
    src_file="/usr/sbin/automount"
    dst_file="/usr/sbin/_automount"

    # Global variable for this script
    NC="`ps -ef | grep 'automount\|autofs' | sed '$d'`"

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
        # check 
        if [ "$1" != "" ]; then
            
            #disable & stop the autofs service
            sudo systemctl disable autofs
            sudo systemctl stop autofs

            #rename service exec file.
            sudo mv $2 $3

            if [ "$1" == "" ]; then
                return 0
            else
                return 1  
            fi
        else
            echo "[INFO] 이미 시스템이 정책에 대한 권고값을 가지고 있습니다. "
            return 0
        fi
        #---------------------------------------------------------------------------------


    }

    #--------------------------------------------------------------------------------------
    # final return
    check()
    {
        if [ "$NC" != "" ]; then
            return 1
        else
            if [ -e $dst_file ]; then
                return 0
            else
                return 1
            fi
        fi
    }

    # execute patch function and return retval
    patch_retval=$(patch $NC $src_file $dst_file)
    # check each result due to know patch() actuall worked it self.
    double_check_retval=$(check $NC $dst_file)

    #--------------------------------------------------------------------------------------