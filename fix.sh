#! /bin/bash

FILES=".vimrc .bash_profile .bashrc .signatures .screenrc \
    bin/randomsignature bin/choice bin/bash-powerline.sh bin/rs"

mkdir ~/bin 2> /dev/null

for FILE in ${FILES}
do
    rm -f ~/"${FILE}" 2> /dev/null
    # echo "${FILE}"
    ln ~/src/dotfiles/"${FILE}" ~/"${FILE}"
done

SAVEIFS="${IFS}"
IFS=$'\n'
for i in $(/bin/ls -d ~/.mozilla/firefox/*.default* ~/Library/Application\ Support/Firefox/Profiles/*.default* 2> /dev/null)
do
    DIR="${i}"/chrome
    # echo "DIR: ${DIR}"
    mkdir "${DIR}" 2> /dev/null

    FILE="${DIR}"/userChrome.css
    # echo "FILE: ${FILE}"
    rm "${FILE}" 2> /dev/null
    ln ~/src/dotfiles/FFuserChrome.css "${FILE}"
done

for i in $(/bin/ls -d ~/.thunderbird/*.default* ~/Library/Thunderbird/Profiles/*.default* 2> /dev/null)
do
    DIR="${i}"/chrome
    # echo "DIR: ${DIR}"
    mkdir "${DIR}" 2> /dev/null

    FILE="${DIR}"/userChrome.css
    # echo "FILE: ${FILE}"
    rm "${FILE}" 2> /dev/null
    ln ~/src/dotfiles/TBuserChrome.css "${FILE}"

    FILE="${i}"/webaccountMail/outlook.office365.com/msgFilterRules.dat
    rm "${FILE}" 2> /dev/null
    ln ~/src/dotfiles/mesFilterRules.dat "${FILE}"
done
IFS="${SAVEIFS}"
