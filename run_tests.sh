#!/usr/bin/env bash

didFail=0
images=("php" "fpm" "apache-php")
versions=("5.6" "php-5.6" "php-5.6")

cwd=$(pwd)
for (( i=0; i<${#images[@]}; i++ ));
do
    cd ${cwd}/${images[i]}
    docker build -t akeneo/${images[i]}:${versions[i]} .

    if ! docker inspect akeneo/${images[i]}:${versions[i]} &> /dev/null; then
        echo $'\timage does not exist!'
        didFail=1
        continue
    fi
done

exit ${didFail}
