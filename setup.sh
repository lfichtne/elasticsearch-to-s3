#! /bin/bash

cat > /etc/yum.repos.d/is_nagios.repo << EOL
# This file was generated by Chef
# Do NOT modify this file by hand.

[is_nagios]
name=SoftLayer IS Nagios
baseurl=http://deploymentdal0101.softlayer.local/repos/softlayer/centos/$releasever/is_nagios/$basearch/
enabled=1
gpgcheck=1
gpgkey=http://deploymentdal0101.softlayer.local/repos/softlayer/SOFTLAYER-INTERNAL-RPM-GPG-KEY
sslverify=true
EOL

yum update

yum groupinstall 'Development Tools'
yum install yajl-devel
yum install ruby-devel
yum install ruby2local
yum install lvm

git clone https://github.com/lfichtne/elasticsearch-to-s3.git
cd elasticsearch-to-s3

/opt/ruby2/bin/gem install bundle
/opt/ruby2/bin/gem install elasticsearch
/opt/ruby2/bin/gem install yajl-ruby
/opt/ruby2/bin/gem list

bundle install
bundle install --deployment
