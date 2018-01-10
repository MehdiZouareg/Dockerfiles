#!/usr/bin/env bash

echo "Apache PHP module version should be 7"

version=`apache2ctl -M | grep "[p]hp7_module"`

if [ ! "$version" ]; then
    echo "Failure"
    exit 1
fi

echo "Success"
exit 0
