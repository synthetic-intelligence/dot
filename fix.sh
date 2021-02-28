#! /bin/bash

cd ~
FILES='.vimrc .bash_profile .bashrc .signatures .screenrc bin/randomsignature bin/choice bin/bash-powerline.sh bin/rs'
mkdir bin 2> /dev/null
rm -f $FILES 2> /dev/null

for i in $FILES
do
    echo $i
    ln ~/src/dotfiles/$i $i
done

mkdir ${release}/chrome 2> /dev/null
release=$(/bin/ls -d ~/.mozilla/firefox/*.default-release)
rm  ${release}/chrome/userChrome.css 2> /dev/null
ln ~/src/dotfiles/userChrome.css ${release}/chrome/userChrome.css

mkdir ${release}/chrome 2> /dev/null
release=$(/bin/ls -d ~/.mozilla/firefox/*.default)
rm  ${release}/chrome/userChrome.css 2> /dev/null
ln ~/src/dotfiles/userChrome.css ${release}/chrome/userChrome.css
