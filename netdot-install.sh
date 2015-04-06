#Criação de superusuário
adduser netdotadmin
#Altera a senha UNIX do usuário
echo netdot | passwd netdotadmin --stdin
groupadd netdot
gpasswd -a netdotadmin netdot
wget https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo rpm -ivh epel-release-7-5.noarch.rpm
#LAMP Server
#Apache
sudo yum install -y httpd
sudo systemctl start httpd.service
#Enable Apache to run on boot
sudo systemctl enable httpd.service
#Install PostgreSQL
#wget http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
#rpm -ivh pgdg-centos94-9.4-1.noarch.rpm 
#yum install -y postgresql94 postgresql94-devel postgresql94-contrib postgresql94-libs postgresql94-test postgresql94-server postgresql94-docs
#/usr/pgsql-9.4/bin/postgresql94-setup initdb
#service postgresql-9.4 start
#chkconfig postgresql-9.4 on
#Install MySQL
sudo yum install -y mariadb-server mariadb
sudo systemctl start mariadb
#Install PHP
sudo yum install -y php php-mysql
sudo systemctl restart httpd.service
#Install dependencies
sudo yum install -y make gcc gcc-c++ autoconf automake rpm-build openssl-devel git perl perl-CPAN perl-Inline
#Install netdot
yum -y install git gcc perl-CPAN tar mysql mysql-devel && curl -L http://cpanmin.us | perl - App::cpanminus
git clone https://github.com/cvicente/Netdot.git
#cd Netdot && ( echo -n mysql;sleep 10;yes) | make rpm-install 
cd Netdot && ( echo -n mysql;yes;yes) | make installdeps 
cd .
#sudo make installdeps
#Install Netdisco
#sudo yum install -y net-snmp net-snmp-utils
#wget http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz -P /tmp
#sudo tar -zxf /tmp/netdisco-mibs-snapshot.tar.gz -C /usr/local/src
#sudo mkdir /usr/local/netdisco
#sudo mv /usr/local/src/netdisco-mibs /usr/local/netdisco/mibs
#sudo cp /usr/local/netdisco/mibs/snmp.conf /etc/snmp/
#sudo systemctl start snmpd.service



#/usr/local/bin/cpanm -n install Apache2::Request Time::Local Net::Appliance::Session BIND::Config::Parser Net::DNS::ZoneFile::Fast Apache2::SiteControl Net::Patricia Authen::Radius Apache2::AuthCookie NetAddr::IP DBD::mysql
#cd /usr/share && curl -L "http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fnetdisco%2Ffiles%2Fnetdisco-mibs%2Flatest-snapshot%2F&ts=1393793276&use_mirror=heanet" |tar zxvf -
