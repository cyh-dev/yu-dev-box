FROM centos:7 AS python_builder

# compile dev
RUN yum -y groupinstall "Development tools" && \
    yum -y install zlib-devel bzip2-devel openssl-devel \
    ncurses-devel sqlite-devel readline-devel tk-devel  \
    gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel wget

RUN cd /tmp && wget https://www.python.org/ftp/python/3.7.5/Python-3.7.5.tar.xz && \
    tar -xf Python-3.7.5.tar.xz && cd Python-3.7.5 && \
    ./configure --prefix=/opt/python/3.7 && \
    make && make install

ARG PIP_INDEX=""
ENV PIP_INDEX=$PIP_INDEX
RUN /opt/python/3.7/bin/python3.7 -m pip install $PIP_INDEX --upgrade pip==21.3.1 && \
    /opt/python/3.7/bin/python3.7 -m pip install $PIP_INDEX virtualenvwrapper==4.8.4 && \
    cd /opt/python && tar -zcf python3.7.tar.gz --exclude=*.pyc 3.7


FROM centos:7

# timezone
ENV TZ Asia/Shanghai
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# passwd
RUN cat /dev/urandom | head -n 10 | md5sum | cut -c 1-10 > /root/.passwd && \
    echo "root:$(cat /root/.passwd)" | chpasswd

# yum
RUN yum -y update ca-certificates && \
    yum -y install epel-release && \
    yum -y install gcc gcc-c++ openssh-server \
	which python-devel python-pip git vim zsh make \
	mysql-devel unixODBC-devel && \
    yum clean all && \
	chsh -s /bin/zsh


# openssh
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -f  /etc/ssh/ssh_host_ed25519_key
RUN sed -i \
    -e 's~^#PermitRootLogin yes~PermitRootLogin yes~g' \
    -e 's~^#PubkeyAuthentication yes~PubkeyAuthentication yes~g' \
    /etc/ssh/sshd_config

# workspace
ENV WORKSPACE="/workspace"
RUN mkdir -p $WORKSPACE
ARG PIP_INDEX=""
ENV PIP_INDEX=$PIP_INDEX

# python2
RUN pip install $PIP_INDEX -U pip==20.3.4 setuptools==44.1.1 wheel==0.36.2
RUN pip install --force-reinstall certifi && sed -i '/DST Root CA X3/,+27d' /usr/lib/python2.7/site-packages/certifi/cacert.pem


# python3
COPY --from=python_builder /opt/python/python3.7.tar.gz /opt/python/python3.7.tar.gz
RUN cd /opt/python && tar -zxf /opt/python/python3.7.tar.gz && rm /opt/python/python3.7.tar.gz && \
    ln -s /opt/python/3.7/bin/python3 /usr/local/bin/python3 && \
    ln -s /opt/python/3.7/bin/pip3 /usr/local/bin/pip3


# zsh 
RUN echo 'if [ ! -d "/workspace/yu-dev-box" ]; then' >> /root/.zshrc && \
    echo '    git clone --recursive https://github.com/cyh-dev/yu-dev-box.git /workspace/yu-dev-box' >> /root/.zshrc && \
    echo 'fi' >> /root/.zshrc && \
    echo 'export YU_DEV_BOX="/workspace/yu-dev-box"' >> /root/.zshrc && \
    echo 'source $YU_DEV_BOX/yu-zshrc.sh' >> /root/.zshrc


WORKDIR $WORKSPACE
VOLUME $WORKSPACE
EXPOSE 22

CMD ["/bin/zsh"]
