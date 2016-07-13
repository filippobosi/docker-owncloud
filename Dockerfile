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
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapUserFilterObjectclass 'person' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapUserFilterMode '1' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapLoginFilterAttributes 'cn' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' hasMemberOfFilterSupport '1' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapLoginFilterEmail '1' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapEmailAttribute 'mail' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapConfigurationActive '1' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapUserFilterObjectclass 'organizationalPerson;person;top;user' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapUserFilterGroups 'Users Owncloud' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapGroupFilter '(&(|(objectclass=group))(|(cn=Users Acquisti ed Economato)(cn=Users Anagrafica)(cn=Users Anticipazioni e Successioni)(cn=Users Assegni)(cn=Users Audit)(cn=Users Avvocati)(cn=Users BackOffice)(cn=Users Bonifici)(cn=Users Cassa Assegni)(cn=Users Cassa Centrale)(cn=Users Cassa Sportello)(cn=Users Compliance)(cn=Users Contabilità Bilancio)(cn=Users Controllo Gestione)(cn=Users Direzione Controllo)(cn=Users Direzione Generale)(cn=Users Family Office)(cn=Users Firme)(cn=Users Fondo Pensione)(cn=Users Gestioni)(cn=Users HelpDesk)(cn=Users IT - HD)(cn=Users IT - SS)(cn=Users KYC)(cn=Users Logistica)(cn=Users Middle Office)(cn=Users NRFO)(cn=Users Organizzazione)(cn=Users Owncloud)(cn=Users Pagamenti)(cn=Users Pensionati)(cn=Users Presenze)(cn=Users Promontory)(cn=Users Rapporti Clientela)(cn=Users Responsabili Pagamenti)(cn=Users Responsabili Settoristi)(cn=Users Responsabili Uffici e Vice)(cn=Users Riscontri Banche)(cn=Users Risk Management)(cn=Users Segreteria)(cn=Users Sereteria Internazionale)(cn=Users Settoristi)(cn=Users Sintacs Eliminatori)(cn=Users Sistemisti)(cn=Users Sviluppo)(cn=Users Swift)(cn=Users Tesoreria)(cn=Users Ufficio Legale)(cn=Users Visa)(cn=Users Visualizzatori POS)))' \			
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapGroupFilterGroups 'Users Acquisti ed Economato;Users Anagrafica;Users Anticipazioni e Successioni;Users Assegni;Users Audit;Users Avvocati;Users BackOffice;Users Bonifici;Users Cassa Assegni;Users Cassa Centrale;Users Cassa Sportello;Users Compliance;Users Contabilità Bilancio;Users Controllo Gestione;Users Direzione Controllo;Users Direzione Generale;Users Family Office;Users Firme;Users Fondo Pensione;Users Gestioni;Users HelpDesk;Users IT - HD;Users IT - SS;Users KYC;Users Logistica;Users Middle Office;Users NRFO;Users Organizzazione;Users Owncloud;Users Pagamenti;Users Pensionati;Users Presenze;Users Promontory;Users Rapporti Clientela;Users Responsabili Pagamenti;Users Responsabili Settoristi;Users Responsabili Uffici e Vice;Users Riscontri Banche;Users Risk Management;Users Segreteria;Users Sereteria Internazionale;Users Settoristi;Users Sintacs Eliminatori;Users Sistemisti;Users Sviluppo;Users Swift;Users Tesoreria;Users Ufficio Legale;Users Visa;Users Visualizzatori POS' \
          	&& php /var/www/html/owncloud/occ ldap:show-config
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapUserFilter '(&(|(objectclass=organizationalPerson)(objectclass=person)(objectclass=top)(objectclass=user))(|(|(memberof=CN=Users Owncloud,CN=Users,DC=ior,DC=local))))' \
			&& php /var/www/html/owncloud/occ ldap:set-config '' ldapLoginFilter '(&(&(|(objectclass=computer)(objectclass=organizationalPerson)(objectclass=person)(objectclass=top)(objectclass=user))(|(|(memberof=CN=Users Owncloud,CN=Users,DC=ior,DC=local)(primaryGroupID=18902))))(|(samaccountname=%uid)(|(mailPrimaryAddress=%uid)(mail=%uid))(|(cn=%uid))))' \

EXPOSE 80 443
USER root
RUN yum install iputils

CMD ["/usr/sbin/apachectl","-k","start","-DFOREGROUND"]
#USER apache
#RUN php /var/www/html/owncloud/occ ldap:test-config ''

