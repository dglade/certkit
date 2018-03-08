
import subprocess

if __name__ == '__main__':
    root_key_name = raw_input('Enter a name for the root private key: ')
    key_length = 0
    while key_length != 2048 and key_length != 4096:
        try:
            key_length = raw_input('Enter the desired key length (2048 or 4096): ')
            key_length = int(key_length)
        except Exception as e:
            print('Invalid key length or format, choose from integgers 2048 or 4096.')
    print('generating new root private key with name {} and length {}'.format(root_key_name, key_length))

    subprocess.call(['./root_cert.sh'])
# openssl genrsa -aes256 -out private/ca.key.pem 4096

# echo 'generating new root certificate'
# openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days 7300 -sha256 -extensions v3_ca -out certs/ca.cert.pem

# echo 'verifying root certificate'
# openssl x509 -noout -text -in certs/ca.cert.pem

# echo 'generating new intermediate private key'
# openssl genrsa -aes256 -out intermediate/private/intermediate.key.pem 4096

# echo 'generating new intermediate csr'
# openssl req -config intermediate/openssl.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -out intermediate/csr/intermediate.csr.pem

# echo 'generating new intermediate certificate'
# openssl req -config intermediate/openssl.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -out intermediate/csr/intermediate.csr.pem

# echo 'verify intermediate certificate'
# openssl x509 -noout -text -in intermediate/certs/intermediate.cert.pem
# openssl verify -CAfile certs/ca.cert.pem intermediate/certs/intermediate.cert.pem

# echo 'creating cerficate chain file'
# cat intermediate/certs/intermediate.cert.pem certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem

# echo 'generating a new server-side private key'
# openssl genrsa -out intermediate/private/final.key.pem 2048

# echo 'generating a new server-side csr'
# openssl req -config intermediate/openssl.cnf -key intermediate/private/final.key.pem -new -sha256 -out intermediate/csr/final.csr.pem

# echo 'generating a new server-side certificate'
# openssl ca -config intermediate/openssl.cnf -extensions server_cert -days 375 -notext -md sha256 -in intermediate/csr/final.csr.pem -out intermediate/certs/server.final.cert.pem

# echo 'generating a new client certificate'
# openssl ca -config intermediate/openssl.cnf -extensions usr_cert -days 375 -notext -md sha256 -in intermediate/csr/final.csr.pem -out intermediate/certs/client.final.cert.pem

# echo 'verify server-side certificate'
# openssl x509 -noout -text -in intermediate/certs/server.final.cert.pem
# openssl verify -CAfile intermediate/certs/ca-chain.cert.pemintermediate/certs/server.final.cert.pem

# echo 'verify client certificate'
# echo 'verify server-side certificate'
# openssl x509 -noout -text -in intermediate/certs/client.final.cert.pem
# openssl verify -CAfile intermediate/certs/ca-chain.cert.pemintermediate/certs/client.final.cert.pem

