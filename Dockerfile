FROM alpine
RUN apk add --update bash ca-certificates openssl krb5-server krb5 && rm -rf /var/cache/apk/* && update-ca-certificates
RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init
WORKDIR /opt
ADD krb5.conf /etc/
ADD krb5kdc/* /var/lib/krb5kdc/
ADD launcher.sh .
ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "/opt/launcher.sh"]
