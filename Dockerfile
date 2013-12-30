FROM fish/collins
MAINTAINER Johannes 'fish' Ziemke <fish@docker.com>

RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list
RUN apt-get -y -q update && apt-get -y -q install ipmitool curl

ADD provision.sh /collins/
ADD conf /collins/conf/
