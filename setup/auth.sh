#!/usr/bin/env sh

PATH=$PATH:/usr/local/bin
set -e

env

auth_usr=$(head -1 $1)

if [ $common_name = $username ]; then
  if [ ! -z "$LDAP_URI" ]; then
    auth_passwd_file=`mktemp`
    echo "Try LDAP Auth on $LDAP_URI for user ${auth_usr}@${LDAP_DOMAIN} $auth_passwd_file"
    tail -1 $1 | tr -d '\n' > "$auth_passwd_file"
    LDAPTLS_REQCERT=allow ldapsearch -x -H "$LDAP_URI" -D "${auth_usr}@${LDAP_DOMAIN}" -y "$auth_passwd_file" -b "" -s base
    res=$?
    #rm "$auth_passwd_file"
    exit $res
  else
    echo "Use users.db"
    auth_passwd=$(tail -1 $1)
    openvpn-user auth --db.path /etc/openvpn/easyrsa/pki/users.db --user ${auth_usr} --password ${auth_passwd}
  fi
else
  echo "Authorization failed"
  exit 1
fi
