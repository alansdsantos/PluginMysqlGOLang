# PluginMysqlGOLang #http_download
[![MySQL UDF](https://img.shields.io/badge/MySQL-UDF-blue.svg)](https://dev.mysql.com/)

[MySQL](https://dev.mysql.com/) Plugin MysqlGOLang

The idea of this plugin is provide a _facade_ for who is moving files (blobs, varbinary) from mysql ot other storage (like s3, or other). You can see how it works in the next steps. This was based on Amazon Linux 2.

Imagine that you have lot's of application and planning to remove blob files from it, and needs to keep the compatibility of the majority of the application for _certain period_, so with this function you can create a view that all these applications will query. Giving you enough time and flexibility to migrate the apps in a planned time window.

We start thinking about it when we had to keep the compatibility of certain apps for certain periods, so we saw this good idea from AWS: https://aws.amazon.com/blogs/aws/mysql_interface/ but our solution works in another way.

Run all this command in order. One of the most important packages is "mysql-devel" it is responsible for the libs "mysql.h" that will help us with specific functions that support us on the devellopment.


**01_MysqlInstallation.txt
</br>02_GoInstallation.txt
</br>03_build.sh**



Reinforcing!! change the password, here is just an example.
[Remembering that we are not responsible for any issue that can happening when using this scripts, you are the responsible for all issues that can happening by any bad utilization of this script, and any running withou understanding of the entire context.]


Setup 
---
- **Clone Source**
```shell
git clone https://github.com/alansdsantos/PluginMysqlGOLang.git
```

- **01_MysqlInstallation.txt - Remember run step-by-step, this file is on root folder of this repository
</br>~/pluginmysqlgolang/01_mysqlinstallation.txt
</br>Read the content and run one by one**


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
</br>
</br>

---
- **02_GoInstallation.txt - Remember run step-by-step, this file is on root folder of this repository
</br>~/pluginmysqlgolang/02_goinstallation.txt
</br>Read the content and run one by one
</br>**

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
</br>
</br>

---
- **03_build.sh - Get into folder, review the file and run it
</br>cd ~/pluginmysqlgolang/pluginmysqlgolang/
</br>sh 03_build.sh
</br>read the content and run carefuly**

```shell
[ssm-user@IP PluginMysqlGOLang]$ sh 03_build.sh
#REMOVE EXISTING COMPILED EXEC FILE
#REMOVE IF EXISTS INTO MYSQL PLUGIN PATH
#CHECK HERE WHERE IS   MYSQL PLUGIN PATH
mysql: [Warning] Using a password on the command line interface can be insecure.
+---------------+--------------------------+
| Variable_name | Value                    |
+---------------+--------------------------+
| plugin_dir    | /usr/lib64/mysql/plugin/ |
+---------------+--------------------------+
#SHOW EXISTING PLUGINS
mysql: [Warning] Using a password on the command line interface can be insecure.
+---------------+-----+------------------+----------+
| name          | ret | dl               | type     |
+---------------+-----+------------------+----------+
| http_download |   0 | http_download.so | function |
+---------------+-----+------------------+----------+
#TAKE CARE, DROP IF EXISTING PLUGIN http_download
mysql: [Warning] Using a password on the command line interface can be insecure.
#SHOW EXISTING PLUGINS AGAIN
mysql: [Warning] Using a password on the command line interface can be insecure.
#STOPS MYSQL SERVICE
#COMPILE EXISTING GO MODULE
#COPY COMPILED FILE TO PLUGIN FOLDER
#STARTS MYSQL SERVICE
#CONNECT AND ATTACH CREATED MYSQL PLUGING TO YOUR MYSQL INSTANCE
mysql: [Warning] Using a password on the command line interface can be insecure.
#SHOW EXISTING PLUGINS AGAIN
mysql: [Warning] Using a password on the command line interface can be insecure.
+---------------+-----+------------------+----------+
| name          | ret | dl               | type     |
+---------------+-----+------------------+----------+
| http_download |   0 | http_download.so | function |
+---------------+-----+------------------+----------+
mysql: [Warning] Using a password on the command line interface can be insecure.
+---------------------------------------------------------------------------------
----------------------------------------------------------------------------------
FILE CONTENT
----------------------------------------------------------------------------------
---------------------------------------------------------------------------------+
[ssm-user@IP PluginMysqlGOLang]$
```

