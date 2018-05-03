#!/usr/bin/env bash
root(){
   cd $1
   rm ca.key.pem
   rm ca.cert.pem
   rm trust.keystore
   openssl genrsa -aes256 -out ca.key.pem -passout pass:Welcome1 4096
   openssl req -key ca.key.pem -new -x509 -days 7300 -sha256 -out ca.cert.pem -passin pass:Welcome1 -batch
   keytool -import -keystore trust.keystore -noprompt -trustcacerts -keypass Welcome1 -storepass Welcome1 -file ca.cert.pem -alias caroot
   openssl x509 -noout -text -in ca.cert.pem -passin pass:Welcome1
}