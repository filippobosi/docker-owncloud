FROM oraclelinux:7
MAINTAINER filippobosi

RUN yum -y update
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y update
RUN rpm --import https://download.owncloud.org/download/repositories/9.0/RHEL_7/repodata/repomd.xml.key
RUN yum -y install wget
RUN wget https://download.owncloud.org/download/repositories/9.0/RHEL_7/ce:9.0.repo -O /etc/yum.repos.d/ce:9.0.repo
RUN yum -y --enablerepo=ol7_optional_latest install owncloud
RUN systemctl enable httpd
EXPOSE 80 443

