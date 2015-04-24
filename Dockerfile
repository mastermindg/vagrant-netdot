FROM centos:7
MAINTAINER @raissa
RUN yum -y install httpd epel-release
#RUN systemctl enable httpd.service
RUN yum -y install make gcc gcc-c++ autoconf automake rpm-build openssl-devel git perl perl-CPAN perl-Inline
RUN yum -y install git gcc perl-CPAN tar mysql mysql-devel make
RUN curl -L http://cpanmin.us | perl - App::cpanminus
RUN yum install -y mod_perl wget
RUN cd /usr/local/src/ && git clone https://github.com/cvicente/Netdot.git netdot
RUN cd /usr/local/src/netdot && (echo -n "mysql";sleep 10;yes ) | make rpm-install
#RUN cpanm --notest RRDs
RUN cpanm --notest GraphViz Module::Build CGI Class::DBI Class::DBI::AbstractSearch Apache2::Request HTML::Mason Apache::Session URI::Escape SQL::Translator SNMP::Info NetAddr::IP Apache2::AuthCookie Apache2::SiteControl Log::Dispatch Log::Log4perl Parallel::ForkManager Net::Patricia Authen::Radius Test::Simple Net::IRR Time::Local File::Spec Net::Appliance::Session BIND::Config::Parser Net::DNS Text::ParseWords Carp::Assert Digest::SHA Net::DNS::ZoneFile::Fast Socket6 XML::Simple
RUN cd /usr/local/src/netdot && make testdeps
RUN yum -y install net-snmp net-snmp-utils
RUN wget http://downloads.sourceforge.net/project/netdisco/netdisco-mibs/latest-snapshot/netdisco-mibs-snapshot.tar.gz -P /tmp
RUN tar -zxf /tmp/netdisco-mibs-snapshot.tar.gz -C /usr/local/src
RUN mkdir /usr/local/netdisco
RUN mv /usr/local/src/netdisco-mibs /usr/local/netdisco/mibs
RUN cp -r /usr/local/netdisco/mibs/snmp.conf /etc/snmp/
#RUN systemctl enable snmpd.service
RUN cp /usr/local/src/netdot/etc/Default.conf /usr/local/src/netdot/etc/Site.conf
RUN cp /usr/local/src/netdot/etc/netdot_apache24_local.conf /etc/httpd/conf.d/
RUN cd /usr/local/src/netdot && make install PREFIX=/usr/local/netdot APACHEUSER=apache APACHEGROUP=apache
CMD ["/sbin/init"]
#CMD systemctl start httpd.service
#CMD cd usr/local/src/netdot && make installdb && service myql start && service snmpd start && service httpd start
