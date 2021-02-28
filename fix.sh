#! /bin/bash

cd ~
mkdir bin
FILES='.vimrc .bash_profile .bashrc .screenrc bin/choice bin/bash-powerline.sh rs'
rm -f $FILES
for i in $FILES
do
    echo $i
    ln -s ~/src/dotfiles/$i $i
done
