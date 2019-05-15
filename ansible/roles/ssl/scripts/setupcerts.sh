#!/bin/bash

KAFKA_HOSTNAME="$(hostname)"

echo "${KAFKA_HOSTNAME}"

keytool -genkey -noprompt -alias localhost -dname "CN=${KAFKA_HOSTNAME}, OU=Woodmark Cloud, O=Woodmark, L=München, S=Bayern, C=GB" -validity 356 -keystore /var/ssl/private/kafka.server.keystore.jks -storepass serpentes -keypass serpentes

keytool -noprompt -keystore /var/ssl/private/kafka.server.keystore.jks -alias localhost -certreq -file /var/ssl/private/cert-file -storepass serpentes

openssl x509 -req -CA /var/ssl/private/ca-cert -CAkey /var/ssl/private/ca-key -in /var/ssl/private/cert-file -out /var/ssl/private/cert-signed -days 356 -CAcreateserial -passin pass:serpentes

keytool -noprompt -keystore /var/ssl/private/kafka.server.keystore.jks -alias CARoot -import -file /var/ssl/private/ca-cert -storepass serpentes

keytool -noprompt -keystore /var/ssl/private/kafka.server.keystore.jks -alias localhost -import -file /var/ssl/private/cert-signed -storepass serpentes
