#chamadas a remote_ip substituídas para client_ip
echo "Apache 2.4 mod_perl fix"
sudo cp /vagrant/modified_files/updatedev /usr/local/netdot/htdocs/rest/updatedev
sudo cp /vagrant/modified_files/host /usr/local/netdot/htdocs/rest/host
sudo cp /vagrant/modified_files/devinfo /usr/local/netdot/htdocs/rest/devinfo
sudo cp /vagrant/modified_files/REST.pm /usr/local/netdot/lib/Netdot/REST.pm
