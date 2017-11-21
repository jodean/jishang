#!/bin/bash
wget -P /home/crane_front_mobile/  $1 --user=liuyi --password=#Abc123
echo "--------------------------dowanload is  done,begin to unzip----------------------------------------"
path=$1
#去头，从开头去除最长匹配前缀
filename=${path##*/}
echo '--------------------------------'
echo $filename
cd /home/crane_front_mobile/
#去尾，从结尾去除最短匹配的后缀
file=${filename%.*}
echo '-------------------------------'
echo $file
unzip $filename -d $file 
mv current /data/tmp
mv $filename /data/tmp
ln -s $file current 
ls -l
