FROM oraclelinux:7
MAINTAINER filippobosi

RUN yum -y update
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y update
RUN rpm --import https://download.owncloud.org/download/repositories/9.0/RHEL_7/repodata/repomd.xml.key
RUN yum -y install wget
RUN wget https://download.owncloud.org/download/repositories/9.0/RHEL_7/ce:9.0.repo -O /etc/yum.repos.d/ce:9.0.repo

RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum -y install php56w-common php56w-process php56w-cli php56w-xml php56w php56w-gd php56w-json php56w-json php56w-ldap php56w-mbstring php56w-mysql php56w-pdo php56w-posix php56w-process php56w-xml php56w-zip php56w-pecl-apcu

RUN yum -y --enablerepo=ol7_optional_latest install owncloud

USER apache
RUN php /var/www/html/owncloud/occ app:enable user_ldap

EXPOSE 80 443

CMD ["/usr/sbin/apachectl","-k","start","-DFOREGROUND"]

