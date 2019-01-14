FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update



#SSHD
RUN apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd
RUN sed -i "s/session.*required.*pam_loginuid.so/#session    required     pam_loginuid.so/" /etc/pam.d/sshd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config

#Runit
RUN apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

#Salt Repo
RUN echo 'deb http://ppa.launchpad.net/saltstack/salt/ubuntu precise main' > /etc/apt/sources.list.d/saltstack.list && \
    wget -q -O- "http://keyserver.ubuntu.com:11371/pks/lookup?op=get&search=0x4759FA960E27C0A6" | apt-key add - && \
    apt-get update

#Salt
RUN apt-get install -y salt-master salt-minion salt-syndic salt-ssh



#Preseed local master-minion
RUN cd /tmp && \
    salt-key --gen-keys=master-minion && \
    mkdir -p /etc/salt/pki/master/minions && \
    cp master-minion.pub /etc/salt/pki/master/minions/master-minion && \
    mkdir -p /etc/salt/pki/minion && \
    cp master-minion.pub /etc/salt/pki/minion/minion.pub && \
    cp master-minion.pem /etc/salt/pki/minion/minion.pem

#Halite
RUN apt-get install -y python-pip gcc python-dev libevent-dev
RUN pip install -U halite && \
    pip install CherryPy

#Halite User
RUN useradd admin && \
    echo "admin:admin" | chpasswd

#Configuration
ADD . /docker

RUN cd /docker && \
    cp --backup -R salt/* /etc/salt && \
    mkdir -p /srv/salt && \
    cp -R srv/* /srv

#Add runit services
ADD sv /etc/service 

ENV HOME /root
WORKDIR /root
EXPOSE 22 3506 8000

