#------------------------------------
#------------------------------------
#ALAN SANTOS
#CONNECT TO LOCAL MYSQL PLEASE
#           !!!CHANGE PASSWORD!!!
#
#
#------------------------------------
#------------------------------------

echo "#REMOVE EXISTING COMPILED EXEC FILE"
rm http_download.so

echo "#REMOVE IF EXISTS INTO MYSQL PLUGIN PATH"
echo "#CHECK HERE WHERE IS   MYSQL PLUGIN PATH"
mysql -u root -p'Teste!123' -h 127.0.0.1 -P 3306 -D mysql -e "SHOW VARIABLES LIKE 'plugin_dir';"
sudo rm /usr/lib64/mysql/plugin/http_download.so

echo "#SHOW EXISTING PLUGINS"
mysql -u root -p'Teste!123' -h 127.0.0.1 -P 3306 -D mysql -e "select * from mysql.func;"

echo "#TAKE CARE, DROP IF EXISTING PLUGIN http_download"
mysql -u root -p'Teste!123' -h 127.0.0.1 -P 3306 -D mysql -e "DROP FUNCTION IF EXISTS http_download;"

echo "#SHOW EXISTING PLUGINS AGAIN"
mysql -u root -p'Teste!123' -h 127.0.0.1 -P 3306 -D mysql -e "select * from mysql.func;"

echo "#STOPS MYSQL SERVICE"
sudo systemctl stop mysqld.service

echo "#COMPILE EXISTING GO MODULE"
go build -buildmode=c-shared -o http_download.so


echo "#COPY COMPILED FILE TO PLUGIN FOLDER"
sudo cp http_download.so /usr/lib64/mysql/plugin/http_download.so

echo "#STARTS MYSQL SERVICE"
sudo systemctl start mysqld.service

echo "#CONNECT AND ATTACH CREATED MYSQL PLUGING TO YOUR MYSQL INSTANCE"
mysql -u root -p'Teste!123' -h 127.0.0.1 -P 3306 -D mysql -e "CREATE FUNCTION http_download RETURNS string SONAME 'http_download.so';"

echo "#SHOW EXISTING PLUGINS AGAIN"
mysql -u root -p'Teste!123' -h 127.0.0.1 -P 3306 -D mysql -e "select * from mysql.func;"

mysql -u root -p'Teste!123' -h 127.0.0.1 -P 3306 -D mysql -e "SELECT  HTTP_DOWNLOAD('http://www.google.com.br') 'image';"


##NEXT STEPS ARE JUST TO ZIP AND COPY TO A S3 BUCKET IF YOU WHANT
#mkdir ~/PluginMysqlGOLang/
#cd ~/PluginMysqlGOLang/
#aws s3 sync s3://YOURS3BUCKETNAME/ ~/PluginMysqlGOLang/
#rm -f ~/PluginMysqlGOLang.zip
#
#sudo zip -q ~/PluginMysqlGOLang.zip ~/PluginMysqlGOLang/*
#
#aws s3 cp /~/PluginMysqlGOLang.zip s3://YOURS3BUCKETNAME/PluginMysqlGOLang.zip
