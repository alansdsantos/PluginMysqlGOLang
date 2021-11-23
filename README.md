# PluginMysqlGOLang #http_download
[![MySQL UDF](https://img.shields.io/badge/MySQL-UDF-blue.svg)](https://dev.mysql.com/)

[MySQL](https://dev.mysql.com/) Plugin MysqlGOLang

The idea of this plugin is provide a facade for who is moving files (blobs, varbinary) from mysql ot other storage (like s3, or other). You can see how it works in the next steps. This was based on Amazon Linux 2.
Remembering change the password, here is just an example.

[Remembering that we are not responsible for any issue that can happening when using this scripts, you are the responsible for all issues that can happening by any bad utilization of this script, and any running withou understanding of the entire context.]

Setup 
---
- **Clone Source**
```shell
git clone https://github.com/alansdsantos/PluginMysqlGOLang.git
```

- **01_MysqlInstallation.txt**
**And**
```sql
REMEMBER RUN STEP-BY-STEP, THIS FILE IS ON ROOT FOLDER OF THIS REPOSITORY
+---------------+-----------------------------------------------+
 ~/PluginMysqlGOLang/01_MysqlInstallation.txt
+---------------+-----------------------------------------------+
READ THE CONTENT AND RUN ONE BY ONE
```

```shell
Execute all the steps manually of this file:
sudo yum update -y
sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum --enablerepo=mysql80-community install mysql-community-server
sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm
sudo yum install mysql-community-server -y
sudo systemctl stop mysqld.service
sudo systemctl start mysqld.service
sudo yum install mysql-devel -y
#kill `cat mysqld.pid`
#sudo grep 'temporary password' /var/log/mysqld.log
MYSQLTMPPWD=$(sudo grep 'temporary password' /var/log/mysqld.log | rev | cut -d" " -f1 | rev)
echo "${MYSQLTMPPWD}"
mysql -u root -p''"${MYSQLTMPPWD}"'' -h 127.0.0.1 -P 3306 -D mysql
```

```sql
/*CHANGE HERE YOUR TEMP PASSWORD*/
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Teste!123';
/*EXIT MYSQL AND TEST IT!*/
```
```shell
mysql -u root -p'Teste!123'
```
```sql
/*ALLOW REMOTE CONNECT*/
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Teste!123';
FLUSH PRIVILEGES;
/*#EXIT MYSQL!*/
```


- **02_GoInstallation.txt**
```sql
REMEMBER RUN STEP-BY-STEP, THIS FILE IS ON ROOT FOLDER OF THIS REPOSITORY
+---------------+-----------------------------------------------+
 ~/PluginMysqlGOLang/02_GoInstallation.txt
+---------------+-----------------------------------------------+
READ THE CONTENT AND RUN ONE BY ONE
```
```shell
sudo yum -y install gcc
sudo yum -y install gcc-c++
mkdir ~/golang
cd ~/golang
wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz
sha256sum go1.13.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.13.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
source ~/.bash_profile
```
- **03_build.sh**
```sql
GET INTO FOLDER, REVIEW THE FILE AND RUN IT
+---------------+-----------------------------------------------+
cd ~/PluginMysqlGOLang/PluginMysqlGOLang/
 sh 03_build.sh
+---------------+-----------------------------------------------+
READ THE CONTENT AND RUN CAREFULY
```
