#entrada de senha sudo script
#echo <senha> | sudo -S <command>
#Criação de superusuário
adduser netdotadmin
#Altera a senha UNIX do usuário
echo netdot | passwd netdotadmin --stdin
groupadd netdot
gpasswd -a netdotadmin netdot
#EPEL
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
sudo rpm -ivh epel-release-7-2.noarch.rpm
#Dependencies
yum install -y make gcc gcc-c++ autoconf automake rpm-build openssl-devel git perl perl-CPAN perl-Inline mod_perl_devel
#LAMP Server
#Apache
yum install -y httpd
systemctl start httpd.service
#Enable Apache to run on boot
systemctl enable httpd.service
#DNSSEC TOOLS
wget --no-check-certificate https://www.dnssec-tools.org/download/dnssec-tools-2.1-1.fc22.src.rpm -O /tmp/dnssec-tools.src.rpm
rpmbuild --rebuild /tmp/dnssec-tools.src.rpm
cd ~/rpmbuild/RPMS/x86_64/
rpm -ivh --nodeps dnssec-tools-*
#Install MySQL
yum install -y mariadb-server mariadb
systemctl start mariadb
systemctl enable mariadb.service
#user root, senha root
#sudo mysql_secure_installation
#senha senha Y Y n n Y
#Install PHP
yum install -y php php-mysql
systemctl restart httpd.service
#Install dependencies
yum install -y make gcc gcc-c++ autoconf automake rpm-build openssl-devel git perl perl-CPAN perl-Inline mod_perl_devel
#Install netdot
cd /usr/local/src/
sudo git clone https://github.com/cvicente/Netdot.git netdot
cd /usr/local/src/netdot/
( echo mysql;yes) | make rpm-install 
#Install Netdisco
yum install -y net-snmp net-snmp-utils
wget http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz -P /tmp
tar -zxf /tmp/netdisco-mibs-snapshot.tar.gz -C /usr/local/src
mkdir /usr/local/netdisco
mv /usr/local/src/netdisco-mibs /usr/local/netdisco/mibs
cp /usr/local/netdisco/mibs/snmp.conf /etc/snmp/
systemctl start snmpd.service
cp /usr/local/src/netdot/etc/Default.conf /usr/local/src/netdot/etc/Site.conf
cp /usr/local/src/netdot/etc/Defalt.conf /vagrant/  
#vi /usr/local/src/netdot/etc/Site.conf
systemctl restart httpd.service
make installdb
make install PREFIX=/usr/local/netdot APACHEUSER=apache APACHEGROUP=apache
cp /usr/local/netdot/etc/netdot_apache24_local.conf /etc/httpd/conf.d/
systemctl restart httpd.service
#Install Cron Jobs
sudo cp /usr/local/netdot/etc/netdot_apache24_local.conf /etc/httpd/conf.d/