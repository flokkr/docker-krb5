#!/usr/bin/env bash
set -e
DESCRIPTOR="$1"
STATEDIR=".state/keytabs"
mkdir -p "$STATEDIR"
while IFS="\n" read -r LINE; do
   STAGE=".stage/keytabs"
   if [ "$LINE" ]; then
      IFS=" " read -r -a PARTS <<< "$LINE"
      STATEFILE="$STATEDIR/$(basename $DESCRIPTOR)/${PARTS[0]}"
      mkdir -p $(dirname $STATEFILE)
      if [ ! -f "$STATEFILE" ]; then
         kubectl exec krb5-0 -- rm /tmp/keytab 1>&2 || true
         kubectl exec krb5-0 -- kadmin -kt /tmp/admin.keytab -p admin/admin -q "addprinc -randkey ${PARTS[1]}" 1>&2
         kubectl exec krb5-0 -- kadmin -kt /tmp/admin.keytab -p admin/admin -q "ktadd -k /tmp/keytab ${PARTS[1]}" 1>&2
         kubectl cp krb5-0:/tmp/keytab "$STATEFILE" 1>&2
      fi
      echo ${PARTS[0]} $(cat $STATEFILE | base64 -w 0)
   fi
done < $DESCRIPTOR
