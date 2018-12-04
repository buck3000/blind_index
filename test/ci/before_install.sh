# install latest libsodium
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz
tar xvfz libsodium-1.0.16.tar.gz
cd libsodium-1.0.16
./configure
make && make check
sudo make install
