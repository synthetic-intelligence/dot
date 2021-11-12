#! /bin/bash

FILES=".vimrc .prsst.yml .bash_profile .bashrc .signatures .screenrc bin/*"

mkdir ~/bin 2> /dev/null

for FILE in ${FILES}
do
    rm -f ~/"${FILE}" 2> /dev/null
    # echo "${FILE}"
    ln ~/src/dotfiles/"${FILE}" ~/"${FILE}"
done

SAVEIFS="${IFS}"
IFS=$'\n'
# sigh, see: https://superuser.com/questions/1507251/firefox-has-two-default-profiles-default-release-and-default-which-one-sho
FF="~/.mozilla/firefox/*.default-release \
    ~/.mozilla/firefox/*.default \
    ~/Library/Application\ Support/Firefox/Profiles/*.default-release \
    ~/Library/Application\ Support/Firefox/Profiles/*.default"

for i in $(/bin/ls -d ${FF} 2> /dev/null)
do
    DIR="${i}"/chrome
    # echo "DIR: ${DIR}"
    mkdir "${DIR}" 2> /dev/null

    FILE="${DIR}"/userChrome.css
    # echo "FILE: ${FILE}"
    rm "${FILE}" 2> /dev/null
    ln ~/src/dotfiles/FFuserChrome.css "${FILE}"
done

TB="~/.thunderbird/*.default \
    ~/.thunderbird/*.default.release \
    ~/Library/Thunderbird/Profiles/*.default \
    ~/Library/Thunderbird/Profiles/*.default.release"

for i in $(/bin/ls -d ${TB} 2> /dev/null)
do
    DIR="${i}"/chrome
    mkdir -p "${DIR}" 2> /dev/null

    FILE="${DIR}"/userChrome.css
    rm "${FILE}" 2> /dev/null
    ln ~/src/dotfiles/TBuserChrome.css "${FILE}"

    DIR="${i}"/webaccountMail/outlook.office365.com
    mkdir -p ${DIR} 2> /dev/null

    FILE="${DIR}"/msgFilterRules.dat
    rm "${FILE}" 2> /dev/null
    ln ~/src/dotfiles/msgFilterRules.dat "${FILE}"

    if ! grep 'toolkit.legacyUserProfileCustomizations.stylesheets' ${i}/prefs.js > /dev/null
    then
        echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> ${i}/prefs.js
    fi
done
IFS="${SAVEIFS}"
