FROM scratch
MAINTAINER Steffen Bleul <blacklabelops@itbleul.de>
ADD blacklabelops-centos7.xz /
RUN yum update -y && \
    yum clean all && rm -rf /var/cache/yum/*
