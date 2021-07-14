#!/bin/bash

URI_ARRAY=`curl --user luwenpeng:LWP@repo https://repo.geedge.net/pulp/content/install/testing/tsg-os-images/ | grep href | awk -F = '{print $2}' | awk -F '"' '{print $2}' | sort -n | grep NPB | tail -n 1`

echo "======================================"
echo "Last TSG-9140-OS: ${URI_ARRAY}"
echo "======================================"

for uri in ${URI_ARRAY[@]}
do
	wget --http-user=luwenpeng --http-password=LWP@repo -c https://repo.geedge.net/pulp/content/install/testing/tsg-os-images/${uri} &
done
