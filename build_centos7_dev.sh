
# timezone
TZ="Asia/Shanghai"
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# yum
yum -y update ca-certificates && \
yum -y install epel-release && \
yum -y install gcc gcc-c++ openssh-server \
	which python-devel python-pip git vim zsh make \
	mysql-devel unixODBC-devel && \
yum clean all && \
chsh -s /bin/zsh

# python2
pip install $PIP_INDEX -U pip==20.3.4 setuptools==44.1.1 wheel==0.36.2
pip install --force-reinstall certifi
sed -i '/DST Root CA X3/,+27d' /usr/lib/python2.7/site-packages/certifi/cacert.pem

# python3
$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )/python/build_python3-centos7.sh

# zshrc
yu_dev_box_path=$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%N}}" )" >/dev/null 2>&1 && pwd )

touch ~/.zshrc
sed -i '/export YU_DEV_BOX/,+1d' ~/.zshrc
echo "export YU_DEV_BOX=\"$yu_dev_box_path\"" >> ~/.zshrc
echo 'source $YU_DEV_BOX/yu-zshrc.sh' >> ~/.zshrc

