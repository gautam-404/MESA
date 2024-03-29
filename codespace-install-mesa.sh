#!/bin/zsh

## Install prerequisites
sudo apt update
yes | sudo apt install build-essential wget curl binutils make perl libx11-6 libx11-dev zlib1g zlib1g-dev tcsh gh ssh

## Install MESA
DIR="/workspaces/software"
echo "export MESASDK_ROOT=$DIR/mesasdk" >> ~/.zshenv
echo "source $DIR/mesasdk/bin/mesasdk_init.sh" >> ~/.zshenv
echo "export MESA_DIR=$DIR/mesa-r15140" >> ~/.zshenv
echo "export OMP_NUM_THREADS=2" >> ~/.zshenv
echo "export GYRE_DIR=$MESA_DIR/gyre/gyre" >> ~/.zshenv

if [ ! -d "$DIR" ]
then
    mkdir $DIR
    # sdk
    curl http://user.astro.wisc.edu/~townsend/resource/download/mesasdk/mesasdk-x86_64-linux-21.4.1.tar.gz --output $DIR/mesasdk-x86_64-linux-21.4.1.tar.gz
    tar xvfz $DIR/mesasdk-x86_64-linux-21.4.1.tar.gz -C $DIR/
    rm -rf $DIR/mesasdk-x86_64-linux-21.4.1.tar.gz
    #mesa
    curl https://zenodo.org/record/4311514/files/mesa-r15140.zip --output $DIR/mesa-r15140.zip
    unzip $DIR/mesa-r15140.zip -d $DIR/
    rm -rf $DIR/mesa-r15140.zip
    source ~/.zshrc
    cd $DIR/mesa-r15140
    ./install
else
    source ~/.zshrc
    cd $MESA_DIR
    cd $DIR/mesa-r15140
    ./clean
    ./install
fi

## Install GYRE
export GYRE_DIR=$MESA_DIR/gyre/gyre
cd $GYRE_DIR
make

cd $DIR
git clone --recurse-submodules  https://github.com/gautam-404/PyMesaHandler.git
cd PyMesaHandler
pip install .
