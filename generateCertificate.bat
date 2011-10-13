@echo off
"D:\Program Files\Apache Software Foundation\Apache2.2\bin\openssl" req -config "D:\Program Files\Apache Software Foundation\Apache2.2\conf\openssl.cnf" -new -out site.csr
pause && cls
"D:\Program Files\Apache Software Foundation\Apache2.2\bin\openssl" rsa -in privkey.pem -out site.key
"D:\Program Files\Apache Software Foundation\Apache2.2\bin\openssl" x509 -in site.csr -out site.cert -req -signkey site.key -days 365
D:\Program Files\Apache Software Foundation\Apache2.2\bin\openssl x509 -in site.cert -out site.der.crt -outform DER
pause && exit