# https://git.dynare.org/Dynare/dynare
# wget and xz-utils for installing the ubuntu dynare instance, the rest for dynare compilation
sudo apt install wget xz-utils build-essential gfortran liboctave-dev libboost-graph-dev libgsl-dev libmatio-dev libslicot-dev libslicot-pic libsuitesparse-dev flex libfl-dev bison autoconf automake texlive texlive-publishers texlive-latex-extra texlive-fonts-extra texlive-latex-recommended texlive-science texlive-plain-generic lmodern python3-sphinx tex-gyre latexmk libjs-mathjax doxygen x13as
wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/dynare/5.1-2build1/dynare_5.1.orig.tar.xz
tar -xf dynare_5.1.orig.tar.xz

# make data folders in advance
mkdir dynare_chains_1 dynare_chains_2 dynare_chains_timed

cd dynare-5.1
sudo ./configure --with-matlab=/opt/matlab/R2022a/ --disable-octave --disable-doc

# https://ahelpme.com/linux/ubuntu/install-and-make-gnu-gcc-10-default-in-ubuntu-20-04-focal/ to get around a versioning error for C++20
sudo apt install -y gcc-10 g++-10 cpp-10
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 --slave /usr/bin/g++ g++ /usr/bin/g++-10 --slave /usr/bin/gcov gcov /usr/bin/gcov-10
sudo make

# https://www.mathworks.com/matlabcentral/answers/329796-issue-with-libstdc-so-6 to allow matlab to launch properly
sudo mv /opt/matlab/R2022a/sys/os/glnxa64/libstdc++.so.6 /opt/matlab/R2022a/sys/os/glnxa64/libstdc++.so.6.old
