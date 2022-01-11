#!/bin/bash

# 목적 : U-05(상) root홈, 패스 디렉터리 권한 및 패스 설정 조치 스크립트
# 내용 : 시스템 내 모든 계정을 대상으로 패스워드 복잡성 설정 여부 및 권고값 설정 여부를 확인하여
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung

ref="U-05.sh"
dst_file1="/etc/profile"
dst_file2="$HOME/.profile"

# check privelige
if [ "$EUID" -ne 0 ]
	then echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit
fi


#--------------------------------------------------------------------------------------
        # exist check common-password file
        if [ -e $dst_file ]; then
            echo "*********************** 취약점 조치 시작 **************************"
                echo " "



                echo "  * root 홈 디렉터리 권한 조치   >   완료"
                chmod 700 $dst_file1

                echo "  * profile PATH 환경변수  접근 제어  >   완료"
                sed -i 's/.:$PATH:|etc|profile/$PATH:|etc|profile:./g' $dst_file1

                echo "  * $HOME/.cshrc PATH 환경변수  접근 제어  >   완료"
                sed -i 's/.:$PATH:$HOME|.cshrc/$PATH:$HOME|.cshrc:./g' $dst_file2

                echo "  * $HOME/.login PATH 환경변수  접근 제어  >   완료"
                sed -i 's/.:$PATH:$HOME\/.login/$PATH:$HOME\/.login:./g' $dst_file2

                echo "  * $HOME/kshrc PATH 환경변수  접근 제어  >   완료"
                sed -i 's/.:$PATH:$HOME|kshrc/$PATH:$HOME|kshrc:./g' $dst_file2

                echo "  * $HOME/.bash_profile PATH 환경변수  접근 제어  >   완료"
                sed -i 's/.:$PATH:$HOME|.bash_profile/$PATH:$HOME|.bash_profile:./g' $dst_file2

                echo "  * /etc/.login PATH 환경변수  접근 제어  >   완료"
                sed -i 's/.:$PATH:|etc|.login/$PATH:|etc|.login:./g' $dst_file1
            
            

            echo " "
            echo "*********************** 취약점 조치 종료 **************************"

            exit 0
        else
            echo "[WARN] 시스템 내에서  $dst_file  파일을 찾을 수 없습니다."
            exit 1
        fi

#--------------------------------------------------------------------------------------