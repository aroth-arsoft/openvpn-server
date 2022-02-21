FROM alpine:3.14
RUN apk add --update bash openvpn easy-rsa openldap-clients && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    wget -q https://github.com/pashcovich/openvpn-user/releases/download/v1.0.3/openvpn-user-linux-amd64.tar.gz -O - | tar xz -C /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*
COPY setup/ /etc/openvpn/setup
ENV LDAP_URI=\
    LDAP_DOMAIN=\
    LDAPTLS_REQCERT=allow
CMD ["/bin/sh", "/etc/openvpn/setup/configure.sh"]
