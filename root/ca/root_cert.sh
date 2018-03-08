#!/bin/bash

MAKE_ROOT=$1
MAKE_INT=$2
MAKE_SERVER=$3
MAKE_CLIENT=$4

if [ $MAKE_ROOT == 'True' ]; then
	echo 'generating new root private key with length 4096 at private/ca.key.pem'
	openssl genrsa -aes256 -out private/ca.key.pem 4096

	echo 'generating new root certificate at certs/ca.cert.pem'
	openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem

	echo 'verifying root certificate'
	openssl x509 -noout -text -in certs/ca.cert.pem
fi

if [ $MAKE_INT == 'True' ]; then
	echo 'generating new intermediate private key with length 4096 at intermediate/private/intermediate.key.pem'
	openssl genrsa -aes256 -out intermediate/private/intermediate.key.pem 4096

	echo 'generating new intermediate csr'
	openssl req -config intermediate/openssl.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -out intermediate/csr/intermediate.csr.pem

	echo 'generating new intermediate certificate'
	openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days 3650 -notext -md sha256 -in intermediate/csr/intermediate.csr.pem -out intermediate/certs/intermediate.cert.pem

	echo 'verify intermediate certificate'
	openssl x509 -noout -text -in intermediate/certs/intermediate.cert.pem
	openssl verify -CAfile certs/ca.cert.pem intermediate/certs/intermediate.cert.pem

	echo 'creating cerficate chain file'
	cat intermediate/certs/intermediate.cert.pem certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem
fi

if [ $MAKE_SERVER == 'True' ]; then
	echo 'generating a new server-side private key'
	openssl genrsa -out intermediate/private/final.key.pem 2048

	echo 'generating a new server-side csr'
	openssl req -config intermediate/openssl.cnf -key intermediate/private/final.key.pem -new -sha256 -out intermediate/csr/final.csr.pem

	echo 'generating a new server-side certificate'
	openssl ca -config intermediate/openssl.cnf -extensions server_cert -days 375 -notext -md sha256 -in intermediate/csr/final.csr.pem -out intermediate/certs/server.final.cert.pem

	echo 'verify server-side certificate'
	openssl x509 -noout -text -in intermediate/certs/server.final.cert.pem
	openssl verify -CAfile intermediate/certs/ca-chain.cert.pem intermediate/certs/server.final.cert.pem
fi

if [ $MAKE_CLIENT == 'True' ]; then
	# echo 'generating a new client csr'
	# openssl req -config intermediate/openssl.cnf -key intermediate/private/final.key.pem -new -sha256 -out intermediate/csr/final.csr.pem

	echo 'generating a new client certificate'
	openssl ca -config intermediate/openssl.cnf -extensions usr_cert -days 375 -notext -md sha256 -in intermediate/csr/final.csr.pem -out intermediate/certs/client.final.cert.pem

	echo 'verify client certificate'
	openssl x509 -noout -text -in intermediate/certs/client.final.cert.pem
	openssl verify -CAfile intermediate/certs/ca-chain.cert.pem intermediate/certs/client.final.cert.pem
fi
