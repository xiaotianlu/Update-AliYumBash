#!/bin/bash
backup(){
	PE=0
        pcd=`pwd`	
	sleep 0.3 
	let PE+=20
	echo $PE
	cd /etc/yum.repos.d/
	sleep 0.3
	let PE+=30
	echo $PE
	rename .repo .back *.repo &>/dev/null
	sleep 0.3
        let PE+=30
	echo $PE
	cd $pcd
	sleep 0.3 
        let PE+=20
        echo $PE

}
download(){
	PE=0
	sleep 0.3 
	let PE+=30
	echo $PE
	wget -O $2 $1 &>/dev/null
        sleep 0.3
        let PE+=70
        echo $PE

}

############main######################
echo "Config ....."
yum install -y dialog &>/dev/null
dialog --title "Install AliYUM Resource" --menu  "Select Your System" 15 30 10 1 "Centos/RHEL 7"  2 "Centos/RHEL 6"  3 "Centos/RHEL 5"  2>select.txt
select=`cat select.txt`
rm -f select.txt 
backup |  dialog --title "Backuping" --gauge "Backup files..." 6 50 0
case $select in
	1)
		download  http://mirrors.aliyun.com/repo/Centos-7.repo /etc/yum.repos.d/Centos-Base.repo  |  dialog --title "Downloading" --gauge "Download BASE Repos.." 6 50 0
		download  http://mirrors.aliyun.com/repo/epel-7.repo  /etc/yum.repos.d/epel.repo  | dialog --title "Downloading" --gauge "Download EPEL Repos.." 6 50 0
		sed -i 's/$releasever/7/g' /etc/yum.repos.d/Centos-Base.repo  &>/dev/null
		rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7 &>/dev/null
	;;
	2)	
		download  http://mirrors.aliyun.com/repo/Centos-6.repo /etc/yum.repos.d/Centos-Base.repo  |  dialog --title "Downloading" --gauge "Download BASE Repos.." 6 50 0
                download  http://mirrors.aliyun.com/repo/epel-6.repo /etc/yum.repos.d/epel.repo  | dialog --title "Downloading" --gauge "Download EPEL Repos.." 6 50 0
                sed -i 's/$releasever/6/g' /etc/yum.repos.d/Centos-Base.repo  &>/dev/null
                rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-6 &>/dev/null
	;;
	3)	
        	download  http://mirrors.aliyun.com/repo/Centos-5.repo /etc/yum.repos.d/Centos-Base.repo  |  dialog --title "Downloading" --gauge "Download BASE Repos.." 6 50 0
                download  http://mirrors.aliyun.com/repo/epel-5.repo /etc/yum.repos.d/epel.repo   | dialog --title "Downloading" --gauge "Download EPEL Repos.." 6 50 0
                sed -i 's/$releasever/5/g' /etc/yum.repos.d/Centos-Base.repo  &>/dev/null
                rpm --import http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-5 &>/dev/null
	;;
esac
yum clean all &>/dev/null
message=`yum repolist 2>/dev/null `
dialog --msgbox "$message" 10 50
dialog --msgbox "    Install Compelete! \n You can run \"yum repolist \" to test! " 10 30
