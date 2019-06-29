# Get electrs and bitcoind on a fresh Ubuntu 18 server

# Install build-essential
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install build-essential

# Install Go
wget https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz
sudo tar -xvf go1.12.6.linux-amd64.tar.gz
sudo mv go /usr/local

# set GO variables
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
go version

# Install Rust
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
cargo version

# Get and Run bitcoind
wget https://bitcoincore.org/bin/bitcoin-core-0.18.0/bitcoin-0.18.0-x86_64-linux-gnu.tar.gz
tar -xvf bitcoin-0.18.0-x86_64-linux-gnu.tar.gz
cd bitcoin-0.18.0/bin
mv bitcoind /usr/local/bin # or wherever you would like to have bitcoind
bitcoind -daemon -testnet # start bitcoind on testnet or mainnet

# Clone, build and run electrs
git clone https://github.com/Blockstream/electrs.git
cd electrs
# change below parameters based on your bitcoind parameters
screen -SL electrs cargo run --release --bin electrs -- -vvvv --daemon-dir /home/<your_username>/.bitcoin --cookie=username:password --daemon-rpc-addr 127.0.0.1:18332 --network testnet --cors 0.0.0.0/0

# Go get and build the Bithyve Wrapper
go get github.com/bithyve/bithyve-wrapper
cd ~/go/src/github.com/bithyve/bithyve-wrapper
go get ./...
go build

# Get an SSL certificate
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
sudo certbot certonly --manual -d <host_name>
sudo cd /etc/letsencrypt/live/<host_name>
cp fullchain.pem server.crt ; cp privkey.pem server.key ; mv server.* ~/go/src/github.com/bithyve/bithyve-wrapper

# Run the bithyve wrapper
cd ~/go/src/github.com/bithyve/bithyve-wrapper
screen -SL wrapper ./bithyve-wrapper