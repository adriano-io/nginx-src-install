#!/bin/bash

# nginx version number 
ngxvn="1.7.1"

# run this script as root user
# stuff needed to build from source
#apt-get install libpcre3-dev build-essential libssl-dev
yum install -y pcre-devel zlib-devel openssl-devel gcc gcc-c++ make openssl-devel libxml2 libxml2-devel libxslt libxslt-devel

 
# get the nginx source
cd /opt/
wget http://nginx.org/download/nginx-$ngxvn.tar.gz
tar -zxvf nginx*

###############################################################
# ...testing area start...
# we'll put the source for nginx modules in here
mkdir /opt/nginxmodules

#...below is not working with nginx 1.7.1...
#cd /opt/nginxmodules

# get the source for the Headers More module - see http://wiki.nginx.org/HttpHeadersMoreModule & http://articles.slicehost.com/2008/5/13/ubuntu-hardy-installing-nginx-from-source
#wget --no-check-certificate http://github.com/agentzh/headers-more-nginx-module/tarball/v0.14
#tar -zxvf v0.14
#mv agentzh-headers-more-nginx-module-2cbbc15 headers-more

#...create init.d script
#vi /etc/init.d/nginx # edit the DEAMON with the correct new path, which is now /usr/local/nginx/sbin/nginx
wget https://raw.githubusercontent.com/fuga-dev/nginx-src-install/master/nginx-initd-script
cp nginx-initd-script /etc/init.d/nginx
chmod 755 /etc/init.d/nginx
# ...testing area end...
###############################################################
cd /opt/nginx*/
 
# configure with chosen modules - see http://wiki.nginx.org/InstallOptions
./configure \
  --conf-path=/etc/nginx/nginx.conf \
  --error-log-path=/var/log/nginx/error.log \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/lock/nginx.lock \
  --http-log-path=/var/log/nginx/access.log \
 #--with-http_dav_module \
 #--http-client-body-temp-path=/var/lib/nginx/body \
  --http-proxy-temp-path=/var/lib/nginx/proxy \
  --with-http_stub_status_module \
  --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
  --with-debug \
  #--add-module=/opt/nginxmodules/headers-more
 
make
make install


#added alias/path for testing
export BASE=/usr/local/nginx/sbin
export PATH=$PATH:$BASE
#echo "alias nginx='/usr/local/nginx/sbin/nginx'" >> ~/.bashrc
#. ~/.bashrc

/etc/init.d/nginx start
