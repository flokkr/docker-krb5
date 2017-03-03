Experimental krb5 Kerberos container. (WORK IN PROGRESS)

Only for development. Not for production.

The docker image contains a rest service which provides keystore and keytab files without any authentication!

Master password: Welcome1

Principal: admin/admin@EXAMPLE.COM Password: Welcome1

Test:

```
docker run --net=host krb5

docker run --net=host -it --entrypoint=bash krb5
kinit admin/admin 
#pwd: Welcome1
klist
```
