#!/bin/sh
# INSTALL
# Swift/T with Julia 1.5
# Sets up paths for Swift/T

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y build-essential swig zsh ant default-jdk default-jre tcl8.6 tcl8.6-dev autoconf

curl https://julialang-s3.julialang.org/bin/linux/x64/1.5/julia-1.5.3-linux-x86_64.tar.gz --output julia-1.5.3-linux-x86_64.tar.gz
tar -xf julia-1.5.3-linux-x86_64.tar.gz

curl https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.5.tar.gz --output openmpi-4.0.5.tar.gz
tar -xf openmpi-4.0.5.tar.gz

cd openmpi-4.0.5

./configure --enable-mpi-java --with-jdk-bindir=/usr/lib/jvm/default-java/bin --with-jdk-headers=/usr/lib/jvm/default-java/include
make
sudo make install
sudo ldconfig

cd  ..

git clone https://github.com/swift-lang/swift-t.git

cp support/swift-t-files/swift-t-settings.sh swift-t/dev/build

cp support/swift-t-files/Makefile.in swift-t/turbine/code/Makefile.in

cp support/swift-t-files/configure.ac swift-t/turbine/code/configure.ac

cp support/swift-t-files/tcl-julia.c swift-t/turbine/code/src/tcl/julia/tcl-julia.c

swift-t/dev/build/build-swift-t.sh

export PATH=$PATH:/home/ubuntu/swift-t-install/stc/bin
export PATH=$PATH:/home/ubuntu/swift-t-install/turbine/bin
