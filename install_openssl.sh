# nmap --script ssl-enum-ciphers localhost
# nmap --script ssl-enum-ciphers <DB SERVER IP>

wget https://www.openssl.org/source/openssl-1.1.1p.tar.gz -O openssl-1.1.1p.tar.gz
tar -zxvf openssl-1.1.1p.tar.gz
cd openssl-1.1.1p
./config
make
make install
ldconfig
openssl version