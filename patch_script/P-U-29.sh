#!/bin/bash

# 목적 : U-29(상)  tftp, talk 서비스 비활성화 조치 스크립트
# 내용 : tfrp, talk 서비스 비활성화
#        ref -> 주요 정보통신 기반 시설 취약점 분석, 평가기준
# Copyright 2021 all reserved Team Hurryup
# Author : Lee Joon Sung


#--------------------------------------------------------------------------------------
# Universal variable
inetd_file="/etc/inetd.conf"
xinetd_file="/etc/xinetd.conf"
tftp="/etc/xinetd.d/tftp"
talk="/etc/xinetd.d/tftp"
ntalk="/etc/xinetd.d/tftp"

# Global variable for this script
chk_inetd="`ps -ef | grep inetd`"
chk_xinetd="`ps -ef | grep xinetd`"

PTMP="`systemctl list-units --type service --all | grep tftp | awk '{print $3}'`"
KTMP="`systemctl list-units --type service --all | grep talk | awk '{print $3}'`"



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
    #check activation status of ' inetd ' service in system
    if [ "$1" != "" ]; then

        sed -i 's/tftp/#tftp/g' $2 #Add remark in front of ' tftp ' setup value
        sed -i 's/talk/#talk/g' $2 #Add remark in front of ' talk ' setup value
        sed -i 's/ntalk/#ntalk/g' $2 #Add remark in front of ' ntalk ' setup value
        
        systemctl restart inetd #restart inetd service

        return 0
    else
        return 0
    fi


    #----------------------------------------------------------------------------------
    #check activation status of ' xinted ' service in system
    if [ "$3" != "" ]; then
        if [ -e $4 ]; then #check existance of service file
            sed -i "8s/.*/disable = yes/g" $4
            return 0
        else
            if [ -e $5 ]; then
                sed -i "8s/.*/disable = yes/g" $5
                return 0
            else
                if [ -e $6 ]; then
                    sed -i "8s/.*/disable = yes/g" $6
                    return 0
                fi
            fi
        fi


        #----------------------------------------------------------------------------------
        #edit xinetd service setup file
        sed -i 's/tftp/#tftp/g' $7 #Add remark in front of ' tftp ' setup value
        sed -i 's/talk/#talk/g' $7 #Add remark in front of ' talk ' setup value
        sed -i 's/ntalk/#ntalk/g' $7 #Add remark in front of ' ntalk ' setup value

        systemctl restart xinetd #restart xinetd daemon

        return 0
    else
        return 0
    fi
    
}


#--------------------------------------------------------------------------------------
# final return
check()
{

if [ "$1" != "" ] && [ "$2" != "" ]; then	
    if [ "$1" = "active" ] && [ "$2" = "active" ]; then
        return 0
    else
        return 1
    fi
else
    return 0
fi

}


#--------------------------------------------------------------------------------------
# execute patch function and return retval
patch_retval=$(patch $chk_inetd $inetd_file $chk_xinetd $tftp $talk $ntalk $xinetd_file)
# check each result due to know patch() actuall worked it self.
double_check_retval=$(check $PTMP $KTMP)

#--------------------------------------------------------------------------------------