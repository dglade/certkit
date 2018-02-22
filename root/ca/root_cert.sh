#!/bin/bash

echo 'generating new root private key'
openssl genrsa -aes256 -out private/ca.key.pem 4096

echo 'generating new root certificate'
openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem

echo 'verifying root certificate'
openssl x509 -noout -text -in certs/ca.cert.pem

echo 'generating new intermediate private key'
openssl genrsa -aes256 -out intermediate/private/intermediate.key.pem 4096

echo 'generating new intermediate csr'
openssl req -config intermediate/openssl.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -out intermediate/csr/intermediate.csr.pem

echo 'generating new intermediate certificate'
openssl req -config intermediate/openssl.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -out intermediate/csr/intermediate.csr.pem

echo 'verify intermediate certificate'
openssl x509 -noout -text -in intermediate/certs/intermediate.cert.pem
openssl verify -CAfile certs/ca.cert.pem intermediate/certs/intermediate.cert.pem

echo 'creating cerficate chain file'
cat intermediate/certs/intermediate.cert.pem certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem

echo 'generating a new server-side private key'
openssl genrsa -out intermediate/private/final.key.pem 2048

echo 'generating a new server-side csr'
openssl req -config intermediate/openssl.cnf -key intermediate/private/final.key.pem -new -sha256 -out intermediate/csr/final.csr.pem

echo 'generating a new server-side certificate'
openssl ca -config intermediate/openssl.cnf -extensions server_cert -days 375 -notext -md sha256 -in intermediate/csr/final.csr.pem -out intermediate/certs/server.final.cert.pem

echo 'generating a new client certificate'
openssl ca -config intermediate/openssl.cnf -extensions usr_cert -days 375 -notext -md sha256 -in intermediate/csr/final.csr.pem -out intermediate/certs/client.final.cert.pem

echo 'verify server-side certificate'
openssl x509 -noout -text -in intermediate/certs/server.final.cert.pem
openssl verify -CAfile intermediate/certs/ca-chain.cert.pemintermediate/certs/server.final.cert.pem

echo 'verify client certificate'
echo 'verify server-side certificate'
openssl x509 -noout -text -in intermediate/certs/client.final.cert.pem
openssl verify -CAfile intermediate/certs/ca-chain.cert.pemintermediate/certs/client.final.cert.pem

# print('generating new root private key')
# keyfile_name = raw_input('Enter a keyfile name: ')

# print('generating a new root certificate')
# certfile_name = raw_input('Enter a certificate file name: ')

# print('verifying certificate {}'.format(certfile_name)