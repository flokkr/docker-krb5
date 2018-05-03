#!/usr/bin/env bash
#!/usr/bin/env bash
issue(){
   cd $1
   NAME=${2:-client}
   rm $NAME.*
   keytool -genkey -keystore $NAME.keystore -storepass Welcome1 -keypass Welcome1 -alias key -dname CN=$NAME,OU=Unknown,L=Unknown
   keytool -keystore $NAME.keystore -keypass Welcome1 -storepass Welcome1 -certreq -alias key -keyalg rsa -file $NAME.csr
   openssl x509 -passin pass:Welcome1  -req  -CA ca.cert.pem -CAkey ca.key.pem -in $NAME.csr -out $NAME.cer -days 365 -CAcreateserial
   keytool -import -keystore $NAME.keystore -noprompt -trustcacerts -keypass Welcome1 -storepass Welcome1 -file ca.cert.pem -alias caroot
   keytool -import -keystore $NAME.keystore -keypass Welcome1 -storepass Welcome1 -file $NAME.cer -alias client
   keytool -list -keystore $NAME.keystore -storepass Welcome1
}