#!/bin/bash

RPM_VERSION_FILE="rpm_version.yml"
if [ ! -f "${RPM_VERSION_FILE}" ]; then
	echo "Please download ${RPM_VERSION_FILE} form https://git.mesalab.cn/tsg/tsg-os-buildimage/"
	exit 0
fi

RPM_ARRAY=`cat ${RPM_VERSION_FILE} | grep ":" | grep "[0-9]" | awk -F ":" '{print $2}'`
for rpm in ${RPM_ARRAY}
do
	printf "[%-35s]\t" "${rpm}"
	is_install=`rpm -qa | grep ${rpm} | wc -l`
	if [ $is_install -eq 1  ];then
		printf "[install]\n"
	else
		printf "\e[31m[uninstall]\e[0m\n"
	fi
done
