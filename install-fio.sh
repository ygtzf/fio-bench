#!/bin/sh

set -x

source /etc/os-release
case $ID in
    debian|ubuntu|devuan)
        apt-get install -y sysstat libaio-devel librbd-devel
        ;;
    centos|fedora|rhel)
        yum install -y sysstat libaio-devel librbd1-devel.x86_64
        ;;
    *)
        exit -1
        ;;
esac

git clone https://github.com/axboe/fio.git
cd fio; ./configure; make
cp fio /usr/bin/
