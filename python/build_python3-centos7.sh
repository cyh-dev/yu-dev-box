#!/bin/bash

python_version="3.7.5"
python_path="/opt/python/3.7"

# install dev lib
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel \
    ncurses-devel sqlite-devel readline-devel tk-devel  \
    gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel wget
yum clean all

# build python
cd /tmp
wget -O Python-$python_version.tar.xz https://www.python.org/ftp/python/$python_version/Python-$python_version.tar.xz
tar -xf Python-$python_version.tar.xz && cd Python-$python_version
./configure --prefix=/opt/python/3.7
make && make install

# pip upgrade
$python_path/bin/python3 -m pip install $PIP_INDEX --upgrade pip==21.3.1
$python_path/bin/python3 -m pip install $PIP_INDEX virtualenvwrapper==4.8.4
ln -sf $python_path/bin/python3 /usr/local/bin/python3
ln -sf $python_path/bin/pip3 /usr/local/bin/pip3
rm -rf /tmp/Python-$python_version*
