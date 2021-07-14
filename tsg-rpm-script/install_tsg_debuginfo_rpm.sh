#!/bin/bash

RPM_VERSION_FILE="rpm_version.yml"
if [ ! -f "${RPM_VERSION_FILE}" ]; then
	echo "Please download ${RPM_VERSION_FILE} form https://git.mesalab.cn/tsg/tsg-os-buildimage/"
	exit 0
fi

RPM_ARRAY=`cat ${RPM_VERSION_FILE} | grep ":" | grep "[0-9]" | awk -F ":" '{print $2}'`
for rpm in ${RPM_ARRAY}
do
	printf "\e[31m debuginfo-install ${rpm}\e[0m\n"
	debuginfo-install -y ${rpm}
done
