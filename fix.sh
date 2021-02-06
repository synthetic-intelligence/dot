#! /bin/bash

cd ~
FILES='.vimrc .bash_profile .bashrc .signatures .screenrc bin/randomsignature bin/choice bin/bash-powerline.sh'
rm -f $FILES
for i in $FILES
do
    echo $i
    ln -s ~/src/dotfiles/$i $i
done
