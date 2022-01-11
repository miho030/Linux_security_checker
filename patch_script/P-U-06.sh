#!/bin/bash

# 목적 : U-06(상) 파일 및 디렉터리 소유자 조치 스크립트
# 내용 : 시스템 내 모든 계정을 대상으로 패스워드 복잡성 설정 여부 및 권고값 설정 여부를 확인하여
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung

ref="U-06.sh"
scan_res="./U-06.json"
tmp_res="./tmp_U-06.json"

# check privelige
if [ "$EUID" -ne 0 ]
	then echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit
fi


#--------------------------------------------------------------------------------------

if [ -e "$scan_res" ]; then
    # if scan file exists, check false value from U-02.json file.
    if [ "false," = "`cat $scan_res | grep -E false | awk '{print $3}'`" ]; then

        # exist check common-password file
        if [ -e $dst_file ]; then
                if [ "소유자" = "`cat $scan_res | grep -E "취약" | grep -E "소유자" | awk '{print $2}'`" ]; then

                    echo "*********************** 취약점 조치 시작 **************************"
                    echo " "

                    comm=$(find / \( -nouser -o -nogroup \) -xdev -ls 2>/dev/null | wc -l)
                    
                    if [ -e $tmp_res ]; then
                        echo " 1"
                    else


# make temp scan result file using echo command.
echo '{
    "title" : "U-06(상) 파일 및 디렉터리 소유자 설정",
    "ref" : "주요 정보통신 기반 시설 취약점 분석, 평가기준",
    "detail" : [
            "[취약] 소유자 혹은 그룹이 없는 파일 및 디렉터리가 존재합니다.",
            ' >> $tmp_res
echo '          "' >> $tmp_res
echo "          $comm" >> $tmp_res
echo '          "' >> $tmp_res
                                    
echo '          ],
    "result" :  false,
    ' >> $tmp_res

# Add timestamp which is from original scan result file(U-06.json)
timestamp=$(cat $scan_res | grep timestamp)
cat tmp_scan_res.json | grep timestamp | awk '{print $1, $2, $3, $4}' >> $tmp_res

# end of making temp scan result file.
echo "}" >> $tmp_res


                    fi

                    echo " "
                    echo "*********************** 취약점 조치 종료 **************************"
        
                fi
        fi
    else
        echo "[WARN] U-06(상) 파일 및 디렉터리 소유자 설정이 모두 권고값으로 설정되어 있습니다."  
    fi  
else
    echo " "
    echo "[WARN] 취약점 진단 결과 파일( $scan_res )을 찾을 수 없습니다 !"
    echo "[INFO] 취약점 진단 스크립트( $ref )를 실행한 이후 "
    echo "       조치 스크립트( $0 )를 실행시켜 주세요."
    echo " "
    exit
fi

#--------------------------------------------------------------------------------------