#! /bin/bash

cd ~
FILES='.bash_profile .bashrc bin/choice bin/bash-powerline.sh'
rm -f $FILES
for i in $FILES
do
    echo $i
    ln dotfiles/$i
done
