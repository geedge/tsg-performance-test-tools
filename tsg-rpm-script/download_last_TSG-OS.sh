#!/bin/bash

BASE_URL="https://repo.geedge.net/pulp/content/install/rc/tsg-os-images/"
#BASE_URL="https://repo.geedge.net/pulp/content/install/testing/tsg-os-images/"

OS_TYPE="NPB"
URI_ARRAY=`curl --user luwenpeng:LWP@repo ${BASE_URL} | grep href | awk -F = '{print $2}' | awk -F '"' '{print $2}' | sort -n | grep ${OS_TYPE} | tail -n 1`

echo "======================================"
echo "Last TSG-OS: ${URI_ARRAY}"
echo "======================================"

for uri in ${URI_ARRAY[@]}
do
	wget --http-user=luwenpeng --http-password=LWP@repo -c ${BASE_URL}${uri} &
done
