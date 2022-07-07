wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/containerd.io_1.6.6-1_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_20.10.9~3-0~ubuntu-bionic_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_20.10.9~3-0~ubuntu-bionic_amd64.deb

sudo apt update
sudo apt install -y libseccomp2:amd64 --upgrade

sudo dpkg -i containerd.io_1.6.6-1_amd64.deb
sudo dpkg -i docker-ce-cli_20.10.9~3-0~ubuntu-bionic_amd64.deb
sudo dpkg -i docker-ce_20.10.9~3-0~ubuntu-bionic_amd64.deb
