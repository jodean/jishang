#!/bin/bash
wget -P /home/crane/  $1 --user=yangkui --password=#Abc123
echo "--------------------------dowanload is  done,begin to unzip----------------------------------------"
path=$1
##去头，从开头去除最长匹配前缀
filename=${path##*/}
echo '--------------------------------'
echo $filename
cd /home/crane/
unzip $filename
mv current /data/tmp/
mv $filename /data/tmp/
##去尾，从结尾去除最短匹配的后缀
file=${filename%.*}
echo '-------------------------------'
echo $file
ln -s $file current
echo 'copy sql script -----------------------------'
cp /home/crane/$file/sql/* /home/flyway-4.2.0/sql/ 
echo 'excute sql-------------------------'
flyway migrate
echo 'sql done'
ls -l
echo 'unzip is done！ are you sure restarting to make it complete? Press yes to make sure an no to concel'
read as
case $as in
Y|y|yes|YES)
systemctl restart crane
journalctl -f -n1000 -ucrane
exit;;
N|n|no|NO)
exit;;
esac
