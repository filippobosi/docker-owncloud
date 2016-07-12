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
#Nei comandi ldap:set-config il primo parametro e' il nome della configurazione che nel caso specifico ha nome vuoto 
RUN php /var/www/html/owncloud/occ maintenance:install --admin-user=admin --admin-pass=password \
			&& php /var/www/html/owncloud/occ app:enable user_ldap \
			&& php /var/www/html/owncloud/occ ldap:create-empty-config \ 
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapAgentName 'CN=Condiviso,OU=Help Desk,OU=Direzione Servizi Informativi,OU=Direzione Generale,OU=Organigramma,DC=ior,DC=local' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapAgentPassword 'condiviso' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapBase 'DC=ior,DC=local' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapBaseGroups 'DC=ior,DC=local' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapBaseUsers 'DC=ior,DC=local' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapHost 'dcmb.ior.local' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapPort '389' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapUserFilter '(&(|(objectclass=person)))' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapLoginFilter '(&(&(|(objectclass=person)))(|(samaccountname=%uid)(|(mailPrimaryAddress=%uid)(mail=%uid))(|(cn=%uid))))' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapUserFilterObjectclass 'person' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapUserFilterMode '1' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapLoginFilterAttributes 'cn' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' hasMemberOfFilterSupport '1' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapLoginFilterEmail '1' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapEmailAttribute 'mail' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapConfigurationActive '1' \
			&& php /var/www/html/owncloud/occ ldap:show-config

EXPOSE 80 443
USER root
RUN yum install iputils

CMD ["/usr/sbin/apachectl","-k","start","-DFOREGROUND"]
#USER apache
#RUN php /var/www/html/owncloud/occ ldap:test-config ''

