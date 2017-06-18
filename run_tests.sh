#!/usr/bin/env bash

images=("php" "fpm" "apache-php" "akeneo-fpm")

cwd=$(pwd)
for (( i=0; i<${#images[@]}; i++ ));
do
    cd ${cwd}/${images[i]}
    docker build -t carcel/${images[i]} .
done
