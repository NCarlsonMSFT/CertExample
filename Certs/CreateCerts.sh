#!/bin/bash

openssl genrsa -out test-ca.private-key.pem 4096
openssl rsa -in test-ca.private-key.pem -pubout -out test-ca.public-key.pem
openssl req -new -x509 -key test-ca.private-key.pem -out test-ca.cert.pem -days 365 -config test-ca.cnf
openssl pkcs12 -export -inkey test-ca.private-key.pem -in test-ca.cert.pem -out test-ca.pfx -passout file:Password.txt
openssl x509 -in test-ca.cert.pem -out test-ca.crt

openssl genrsa -out backend.private-key.pem 4096
openssl rsa -in backend.private-key.pem -pubout -out backend.public-key.pem
openssl req -new -sha256 -key backend.private-key.pem -out backend.csr -config backend.cnf
openssl x509 -req -in backend.csr -CA test-ca.cert.pem -CAkey test-ca.private-key.pem -CAcreateserial -out backend.cer -days 365 -sha256 -extfile backend.cnf -extensions req_v3
openssl pkcs12 -export -inkey backend.private-key.pem -in backend.cer -out backend.pfx -passout file:Password.txt

openssl genrsa -out frontend.private-key.pem 4096
openssl rsa -in frontend.private-key.pem -pubout -out frontend.public-key.pem
openssl req -new -sha256 -key frontend.private-key.pem -out frontend.csr -config frontend.cnf
openssl x509 -req -in frontend.csr -CA test-ca.cert.pem -CAkey test-ca.private-key.pem -CAcreateserial -out frontend.cer -days 365 -sha256 -extfile frontend.cnf -extensions req_v3
openssl pkcs12 -export -inkey frontend.private-key.pem -in frontend.cer -out frontend.pfx -passout file:Password.txt
