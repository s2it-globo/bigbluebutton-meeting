#/bin/bash

# sed -i '8i SAN="email:support@example.com"' /usr/lib/ssl/openssl.cnf

# sed -i '219i subjectAltName=${ENV::SAN}' /usr/lib/ssl/openssl.cnf

# sed -i '228i subjectAltName=${ENV::SAN}' /usr/lib/ssl/openssl.cnf

export SAN="DNS:$1"

if [ -f "/etc/nginx/ssl/bigbluebutton.crt" ]; then
  rm /etc/nginx/ssl/bigbluebutton.crt
fi


if [ -f "/etc/nginx/ssl/bigbluebutton.key" ]; then
  rm /etc/nginx/ssl/bigbluebutton.key
fi

#gerando certificado ja com todos os parametros
/usr/bin/openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/CN='+$1+'/O=BigBlueButton, Inc./C=US/ST=Oregon/L=Portland' -nodes -out /etc/nginx/ssl/bigbluebutton.crt -keyout /etc/nginx/ssl/bigbluebutton.key

