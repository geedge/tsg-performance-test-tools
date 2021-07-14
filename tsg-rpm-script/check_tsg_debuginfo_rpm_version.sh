#!/bin/bash

# 验证 debufinfo 的版本与软件 rpm 的版本是否一致
verify_debuginfo_rpm_version()
{
	rpm_name=${1}
	printf "[%-35s]\t" "${rpm_name}"
	rpm_vers=`echo ${rpm_name} | awk -F "-[0-9]" '{print $2}'`
	is_match=`rpm -qa | grep ${rpm_vers} | wc -l`
	if [ ${is_match} -eq 2  ]; then
		printf "[OK]\n"
	else
		printf "\e[31m[FAIL]\e[0m\n"
	fi 
}

RPM_VERSION_FILE="rpm_version.yml"
if [ ! -f "${RPM_VERSION_FILE}" ]; then
	echo "Please download ${RPM_VERSION_FILE} form https://git.mesalab.cn/tsg/tsg-os-buildimage/"
	exit 0
fi

RPM_ARRAY=`cat ${RPM_VERSION_FILE} | grep ":" | grep "[0-9]" | awk -F ":" '{print $2}'`
for rpm in ${RPM_ARRAY}
do
	verify_debuginfo_rpm_version ${rpm}
done
