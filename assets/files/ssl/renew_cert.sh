#!/usr/bin/sh

#定义脚本根路径
path="/home/application/ssl_www"

dt=date+%Y-%m-%d

if [ -d $path ];then
	if [ -f "${path}/acme_tiny.py" ];then
		if [ -f "${path}/account.key" ];then
			if [ -f "${path}/domain.csr" ];then
				if [ -d "${path}/tmp/" ];then
					python ${path}/acme_tiny.py --account-key ${path}/account.key --csr ${path}/domain.csr --acme-dir $path > ${path}/tmp/signed_${dt}.crt || exit
					if [ -f "${path}/tmp/signed_${dt}.crt" ];then
						wget -O - https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem > ${path}/tmp/intermediate.pem
						cat ${path}/tmp/signed_${dt}.crt ${path}/tmp/intermediate.pem > ${path}/chained.pem
						nginx -s reload
					else
						echo "文件 ${path}/tmp/signed_${dt}.crt 拉取不成功"
					fi
				else
					mkdir ${path}/tmp
					python ${path}/acme_tiny.py --account-key ${path}/account.key --csr ${path}/domain.csr --acme-dir $path > ${path}/tmp/signed_${dt}.crt || exit
					if [ -f "${path}/tmp/signed_${dt}.crt" ];then
						wget -O - https://letsencrypt.org/certs/lets-encrypt-x1-cross-signed.pem > ${path}/tmp/intermediate.pem
						cat ${path}/tmp/signed_${dt}.crt ${path}/tmp/intermediate.pem > ${path}/chained.pem
						nginx -s reload
					else
						echo "文件 ${path}/tmp/signed_${dt}.crt 拉取不成功"
					fi
				fi
			else
				echo "必要文件 ${path}/domain.csr 不存在"
			fi
		else
			echo "必要文件 ${path}/account.key 不存在"
		fi
	else
		echo "必要文件 ${path}/acme_tiny.py 不存在"
	fi
else
	echo "文件夹不存在"
fi
