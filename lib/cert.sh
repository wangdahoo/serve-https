#!/bin/sh

pass=victory
tmp=.tmp

ca_key=$tmp/rootCA.key
ca_pem=$tmp/rootCA.pem
server_csr=$tmp/server.csr
server_key=$tmp/server.key
server_crt=$tmp/server.crt

mkdir -p .tmp

# 生存 CA 证书
echo '生成CA证书秘钥'
openssl genrsa -des3 -passout pass:$pass -out $ca_key 2048
echo '生成CA证书'
openssl req -x509 -new -nodes -key $ca_key -sha256 -days 1024 -passin pass:$pass -out $ca_pem -config server.csr.cnf

# 生成自签证书
echo '生成 server.key'
openssl req -new -sha256 -nodes -out $server_csr -newkey rsa:2048 -keyout $server_key -config server.csr.cnf
echo '生成 server.crt'
openssl x509 -req -in $server_csr -CA $ca_pem -CAkey $ca_key -CAcreateserial -passin pass:$pass -out $server_crt -days 500 -sha256 -extfile v3.ext
