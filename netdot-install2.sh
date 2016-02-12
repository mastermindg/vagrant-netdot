#Install EPEL 
yum install -y epel-release

#Install Apache
yum -y install httpd rrdtool
service httpd start

#Install myql
wget -O /etc/yum.repos.d/MariaDB.repo http://mariadb.if-not-true-then-false.com/centos/$(rpm -E %centos)/$(uname -i)/10
yum install -y mariadb-server mariadb
service mysql start

#Install netdot
yum -y install mod_perl wget git gcc perl-CPAN tar mysql mysql-devel && curl -L http://cpanmin.us | perl - App::cpanminus
cd /usr/local/src/
git clone https://github.com/cvicente/Netdot.git netdot
cd /usr/local/src/netdot/
(echo -n mysql;sleep 10;yes) | make rpm-install
#Install netdot's dependencies
/usr/local/bin/cpanm --notest GraphViz Module::Build CGI Class::DBI Class::DBI::AbstractSearch Apache2::Request HTML::Mason Apache::Session URI::Escape SQL::Translator SNMP::Info NetAddr::IP Apache2::AuthCookie Apache2::SiteControl Log::Dispatch Log::Log4perl Parallel::ForkManager Net::Patricia Authen::Radius Test::Simple Net::IRR Time::Local File::Spec Net::Appliance::Session BIND::Config::Parser Net::DNS Text::ParseWords Carp::Assert Digest::SHA Net::DNS::ZoneFile::Fast Socket6 XML::Simple

#Install DNSSEC Tools
yum install -y rpm-build
wget --no-check-certificate https://www.dnssec-tools.org/download/dnssec-tools-2.1-1.fc22.src.rpm -O /tmp/dnssec-tools.src.rpm
rpmbuild --rebuild /tmp/dnssec-tools.src.rpm
cd ~/rpmbuild/RPMS/x86_64/
sudo rpm -ivh --nodeps dnssec-tools-*

#Install Netdisco
yum -y install net-snmp net-snmp-utils
wget http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz -P /tmp
tar -zxf /tmp/netdisco-mibs-snapshot.tar.gz -C /usr/local/src
mkdir /usr/local/netdisco
mv /usr/local/src/netdisco-mibs /usr/local/netdisco/mibs
cp /usr/local/netdisco/mibs/snmp.conf /etc/snmp/
service snmpd start

cp /usr/local/src/netdot/etc/Default.conf /usr/local/src/netdot/etc/Site.conf
cp /usr/local/src/netdot/etc/Site.conf /vagrant/Site.conf

make installdb
make install PREFIX=/usr/local/netdot APACHEUSER=apache APACHEGROUP=apache
cp /usr/local/netdot/etc/netdot_apache24_local.conf /etc/httpd/conf.d/

#Apache 2.4 mod_perl fix
sh /vagrant/apache_2_4_mod_perl_fix.sh

# Restart Apache
service httpd restart

#Install Cron Jobs
sudo cp /usr/local/netdot/etc/netdot_apache24_local.conf /etc/httpd/conf.d/
