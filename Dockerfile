FROM oraclelinux:7
MAINTAINER filippobosi

RUN yum -y update \
	&& rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
	&& yum -y update \
	&& rpm --import https://download.owncloud.org/download/repositories/9.0/RHEL_7/repodata/repomd.xml.key \
	&& yum -y install wget \
	&& wget https://download.owncloud.org/download/repositories/9.0/RHEL_7/ce:9.0.repo -O /etc/yum.repos.d/ce:9.0.repo \
	&& rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
	&& yum -y install php56w-common php56w-process php56w-cli php56w-xml php56w php56w-gd php56w-json php56w-json php56w-ldap php56w-mbstring php56w-mysql php56w-pdo php56w-posix php56w-process php56w-xml php56w-zip php56w-pecl-apcu \
	&& yum -y --enablerepo=ol7_optional_latest install owncloud

USER apache
RUN php /var/www/html/owncloud/occ maintenance:install --admin-user=admin --admin-pass=password \
			&& php /var/www/html/owncloud/occ app:enable user_ldap \
			&& php /var/www/html/owncloud/occ ldap:create-empty-config \ 
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapAgentName 'CN=Condiviso,OU=Help Desk,OU=Direzione Servizi  Informativi,OU=Direzione Generale,OU=Organigramma,DC=ior,DC=local' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapAgentPassword 'Condiviso' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapBase 'DC=ior,DC=local' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapHost 'dcmbb.ior.local' \
			&& php /var/www/html/owncloud/occ ldap:show-config


EXPOSE 80 443
USER root
CMD ["/usr/sbin/apachectl","-k","start","-DFOREGROUND"]

