#!/bin/bash

# 목적 : U-17(상) $HOME/.rhosts, hosts.equiv 사용 금지 조치 스크립트
# 내용 : U-17(상) $HOME/.rhosts, hosts.equiv 파일의 접근 및 사용을 차단한다.
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
STEP1="$HOME/.rhosts"
STEP2="hosts.equiv"

# Global variable for this script

#--------------------------------------------------------------------------------------
# check privelige
if [ "$EUID" -ne 0 ]
	then echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit 1
fi

#--------------------------------------------------------------------------------------
patch()
{
    # just for patch() result
    r_resval=1
    s_resval=1

	# check existance of destination file for modification.
	if [ -e $1 ]; then

        # change file owner permission to ' root '
        chown root $1
        # change file permission to ' 400 '
        chmod 400 $1
        r_resval=0
	
    else
        echo "[WARN] 시스템 내에서  ( $STEP1 ) 파일을 찾을 수 없습니다."
    fi



    if [ -e $2 ]; then
        # change file owner permission to ' root '
        chown root $2
        # change file permission to ' 400 '
        chmod 400 $2
        s_resval=0
    else
        echo "[WARN] 시스템 내에서  ( $STEP1 ) 파일을 찾을 수 없습니다."
    fi


    if [ r_resval = 0 ] && [ s_resval = 0 ]; then
        return 0
    else
        return 1
    fi
}

#--------------------------------------------------------------------------------------
# final return
check()
{
    # define universal variable due to check ' actually patch() function has been execute. '
    mod='-r--------'
    own='root'

    if [ -e $1 ]; then
		S1O=`ls -l $STEP1 | awk '{print $3}'`
		S1P=`ls -l $STEP1 | awk '{print $1}'`
    
        if [ $S1O = $own ] && [ $S1P = $mod ]; then
            return 0
        else
            echo "tet"
            return 1
        fi
    else
        echo "tet"
        return 1
    fi

    if [ -e $2 ]; then
        S2O=`ls -l $STEP1 | awk '{print $3}'`
		S2P=`ls -l $STEP1 | awk '{print $1}'`

        if [ $S20 = $own ] && [ $S2P = $mod ]; then
            return 0
        else
            echo "tet"
            return 1
        fi
    else
        echo "tet"
        return 1
    fi
}

# execute patch function and return retval
patch_retval=$(patch $STEP1 $STEP2)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $STEP1 $STEP2)
#--------------------------------------------------------------------------------------