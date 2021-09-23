#!/bin/bash

check_rpm_version()
{
	rpm=$1
	rpmdb=$2
	printf "%-35s\t" "${rpm}"
	is_install=`cat ${rpmdb} | grep ${rpm} | wc -l`
	if [ $is_install -eq 1 ]; then
		printf "\e[32m[install]\e[0m\n"
	else
		printf "\e[31m[uninstall]\e[0m\n"
	fi
}

install_rpm_debugino()
{
	printf "\e[31m debuginfo-install -y %-35s\e[0m\n" "${rpm}"
	debuginfo-install -y $1
}

verify_debuginfo_version()
{
	rpm=$1
	rpmdb=$2
	printf "%-35s debuginfo\t" "${rpm}"
	version=`echo ${rpm} | awk -F "-[0-9]" '{print $2}'`
	is_match=`cat ${rpmdb} | grep ${version} | wc -l`
	if [ ${is_match} -eq 2 ]; then
		printf "\e[32m[correct]\e[0m\n"
	else
		printf "\e[31m[incorrect]\e[0m\n"
	fi
}

download_only_rpm()
{
	debuginfo=`echo $1 | awk -F '-' '{print $1 "-debuginfo-" $2}'`
	devel=`echo $1 | awk -F '-' '{print $1 "-devel-" $2}'`
	printf "\e[31m yum install --downloadonly %-35s %-35s %-35s\e[0m\n" "$1 $debuginfo $devel"
	yum install --downloadonly --downloaddir=./ $1
	yum install --downloadonly --downloaddir=./ $debuginfo
	yum install --downloadonly --downloaddir=./ $devel
}

usage()
{
	printf "	-c	Check whether the rpm specified by tsg-os is installed\n"
	printf "	-i	Install debuginfo corresponding to rpm\n"
	printf "	-v	Verify that the version of debuginfo installed is correct\n"
	printf "	-d	Download only rpm/devel/debuginfo\n"
	printf "	-h	Help\n"
	exit 0
}

RPM_DB=".tmp.rpm.db"
RPM_VERSION_FILE="rpm_version.yml"
if [ ! -f "${RPM_VERSION_FILE}" ]; then
	echo "Please download last ${RPM_VERSION_FILE} form https://git.mesalab.cn/tsg/tsg-os-buildimage/"
	exit 0
fi

if [ "$1" == "" ]; then
	usage
fi

opt_type="h"
while getopts civhd opt
do
	case $opt in
		c) opt_type="c" ;;
		i) opt_type="i" ;;
		v) opt_type="v" ;;
		d) opt_type="d" ;;
		h|?) usage ;;
	esac
done

rpm -qa >> ${RPM_DB}
RPM_ARRAY=`cat ${RPM_VERSION_FILE} | grep ":" | grep "[0-9]" | awk -F ":" '{print $2}' | sort`
for rpm in ${RPM_ARRAY}
do
	if [ $opt_type == "c" ]; then
		check_rpm_version ${rpm} ${RPM_DB}
	elif [ $opt_type == "i" ]; then
		install_rpm_debugino ${rpm}
	elif [ $opt_type == "v" ]; then
		verify_debuginfo_version ${rpm} ${RPM_DB}
	elif [ $opt_type == "d" ]; then
		download_only_rpm ${rpm}
	fi
done
rm -rf ${RPM_DB}
