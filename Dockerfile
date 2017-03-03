FROM frolvlad/alpine-oraclejdk8:slim
RUN apk add --update bash ca-certificates openssl krb5-server krb5 && rm -rf /var/cache/apk/* && update-ca-certificates
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init
WORKDIR /opt
ADD krb5.conf /etc/
ADD kadm5.acl /var/lib/krb5kdc/kadm5.acl
RUN kdb5_util create -s -P Welcome1
RUN kadmin.local -q "addprinc -randkey admin/admin@EXAMPLE.COM"
RUN kadmin.local -q "ktadd -k /tmp/admin.keytab admin/admin@EXAMPLE.COM"
ADD launcher.sh .
ADD issuer /root/issuer
ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/opt/launcher.sh"]
