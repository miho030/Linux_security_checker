#!/bin/bash
# U-01 (상) root 계정 원격접속 제한 조치 스크립트

SSH="/etc/ssh/sshd_config"
LOGIN="/etc/pam.d/login"

#check privelige
if [ "$EUID" -ne 0 ]; then
	echo "root 권한으로 스크립트를 실행하여 주십시오."
	exit
fi



echo "*********************** 취약점 조치 시작 **************************"

# this is for result
ssh_res=1

# ssh root connect setup
echo ""
echo "            <<   ssh root 권한 접근 제어 설정   >>            "
echo ""
if [ -e $SSH ]; then
	# check detail setting value in file.
	if [ "PermitRootLogin no" = "`cat $dst_File | grep -E ^PermitRootLogin`" ]; then
		echo "[SAFE] 이미 ssh 접속 시 root 권한 접근에 대한 권고값이 설정되어 있습니다." 
		ssh_res=1

	else
		echo "[WARN] ssh 접속 시 root 권한 접근이 허용되는 취약점이 있습니다 !"
		sed -i "s/'#PermitRootLogin prohibit-password'/'PermitRootLogin no'/g" $dst_File
		echo "[SECURED] ssh 접속 시 root 권한 접근 해제 설정 완료"
		ssh_res=0
	fi
else
	echo "[INFO] 시스템 내에서 ( $dst_file )  파일을 찾을 수 없습니다 !"
fi

#--------------------------------------------------------------------------------------------------------------------

# for result
login_res=1

echo ""
echo "            <<   telnet root 권한 접근 제어 설정   >>            "
echo ""
if [ -e $LOGIN ]; then
	if [ -n "`cat /etc/pam.d/login | grep -E "^auth required /lib/security/pam_securetty.so"`" ]; then
		echo "[SAFE] telnet 일반 계정 로그인만 가능합니다."
		login_res=1
	else
		echo "[WARN] telnet 접속 시 root 권한 접근이 허용되는 취약점이 있습니다 !"
		echo "auth required /lib/security/pam_securetty.so" >> /etc/pam.d/login
		sed -i 's/#auth required |lib|security|pam_securetty.so/auth required |lib|security|pam_securetty.so/g' /etc/pam.d/login
		echo "[SECURED] telnet에서 일반계정만 로그인 가능합니다."
		login_res=0
	fi
else
	echo "[INFO] securetty.so 설정 파일을 찾을 수 없습니다 !"
fi

echo "*********************** 취약점 조치 종료 **************************"


if [ $ssh_res = 0 ] && [ $login_res = 0 ]; then
	exit 0
else
	exit 1
fi