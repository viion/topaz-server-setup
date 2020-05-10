#!/usr/bin/env bash

# Default mysql pw for root, change this.
MYSQL_DEFAULT_PASSWORD=test

sudo apt update -y
sudo apt dist-upgrade -y

sudo apt-get autoremove -y
sudo apt-get autoclean -y

# MySQL Defaults
echo "mysql-server mysql-server/root_password password $MYSQL_DEFAULT_PASSWORD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_DEFAULT_PASSWORD" | debconf-set-selections

# required dependencies
sudo apt-get install zlib1g-dev libssl-dev -y
sudo apt-get install -y
sudo apt-get install mariadb-server libmariadb-dev-compat -y
sudo apt-get install libluajit-5.1-dev libzmq3-dev autoconf pkg-config -y

# Clone Project Topaz
git clone --recursive https://github.com/project-topaz/topaz.git

# Install
cd topaz
sh autogen.sh
./configure --enable-debug=gdb
make -j $(nproc)

# Setup SQL
mysql -uroot -p$MYSQL_DEFAULT_PASSWORD < ./db_ffxi_topaz_setup.sql

# Import FFXI SQL files
cd sql
for f in *.sql
  do
     echo -n "Importing $f into the database..."
     mysql tpzdb -u topazadmin -ptopazisawesome < $f && echo "Success"      
  done
cd ..


# Get IP for public use
# todo - var this into an SQL command then remove the update file
# dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}'
mysql -uroot -p$MYSQL_DEFAULT_PASSWORD < ./db_ffxi_topaz_update.sql

# Copy config files
cp conf/default/* conf/

# Update configs
sudo sed -i "s|mysql_login:     root|mysql_login:     topazadmin|" ~/topaz/conf/login.conf
sudo sed -i "s|mysql_password:  root|mysql_password:  topazisawesome|" ~/topaz/conf/login.conf
sudo sed -i "s|mysql_login:     root|mysql_login:     topazadmin|" ~/topaz/conf/map.conf
sudo sed -i "s|mysql_password:  root|mysql_password:  topazisawesome|" ~/topaz/conf/map.conf
sudo sed -i "s|mysql_login:     root|mysql_login:     topazadmin|" ~/topaz/conf/search_server.conf
sudo sed -i "s|mysql_password:  root|mysql_password:  topazisawesome|" ~/topaz/conf/search_server.conf

# Setup port forwarding
sysctl net.ipv4.ip_forward=1
sudo ufw allow from any to any port 54230 proto tcp
sudo ufw allow from any to any port 54231 proto tcp
sudo ufw allow from any to any port 54001 proto tcp
sudo ufw allow from any to any port 54002 proto udp
sudo ufw allow from any to any port 54230 proto tcp

# Start server, the screen console will be logged to file
screen -L -Logfile ~/screen_topaz_connect.log -d -m -S topaz_connect ./topaz_connect
screen -L -Logfile ~/screen_topaz_game.log -d -m -S topaz_game ./topaz_game
screen -L -Logfile ~/screen_topaz_search.log -d -m -S topaz_search ./topaz_search

# All done
echo "FFXI Project Topaz Server is setup and running"
