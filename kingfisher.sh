#!/bin/bash
read -p "Please give your address: " addr
path=$addr
filename=${path##*/}

echo '+++++++++++++++++------------------+++++++++++++++++++'
file=${filename%.*}
services=(ticket projekt connect thirdparty operation statistics forward socketio order)
for((i=0;i<${#services[*]};i++))
do
	if [[ $file =~ ${services[$i]} ]]
	then
		service=${services[$i]}
		service_dir=/data/kingfisher/$service
		logfile=/var/log/kingfisher-$service/kingfisher-$service.log
	fi
done

echo '<<<<<<<<<<<<<<<<<<<------------------>>>>>>>>>>>>>>>>>>>>'
echo -e "\033[41;37m We will update kingfisher-$service.service \033[0m"

if [ ! -d "$service_dir" ]; then
  exit 123
fi

cd $service_dir
wget -P $service_dir $addr --user=yangkui --password=#Abc123
unzip -q $filename
scp $filename kfconfig02:$service_dir/
rm -f *.zip current
ln -s $file current
echo -e "\033[47;30m Check the $service version \033[0m"
echo '+++++++++++++++++------------------+++++++++++++++++++'
echo '<<<<<<<<<<<<<<<<<<<------------------>>>>>>>>>>>>>>>>>>>>'
ls -l
echo -e "\033[45;37m The package version is $file \033[0m"
echo '+++++++++++++++++------------------+++++++++++++++++++'
echo '<<<<<<<<<<<<<<<<<<<------------------>>>>>>>>>>>>>>>>>>>>'
echo -e "\033[47;41m Restart service kingfisher-$service \033[0m"
systemctl restart kingfisher-$service.service

echo '+++++++++++++++++------------------+++++++++++++++++++'
echo '<<<<<<<<<<<<<<<<<<<------------------>>>>>>>>>>>>>>>>>>>>'
echo -e "\033[44;37m We will update kfconfig02 $file \033[0m"
ssh root@kfconfig02 "
cd $service_dir
unzip -q $filename
rm *.zip current
ln -s $file current
systemctl restart kingfisher-$service.service
"
echo '+++++++++++++++++------------------+++++++++++++++++++'
echo '<<<<<<<<<<<<<<<<<<<------------------>>>>>>>>>>>>>>>>>>>>'
echo -e "\033[42;37m Cat service $service $logfile \033[0m"
tail -n100 -f $logfile
