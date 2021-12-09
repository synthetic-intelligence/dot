#! /bin/bash

FILES=".vimrc .prsst.yml .bash_profile .bashrc .signatures .screenrc bin/*"

if [[ $(uname) == Linux ]]
then
  for uuid in $(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "',")
do
    A='org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:'
        gsettings set "${A}${uuid}"/ cursor-blink-mode off
        gsettings set "${A}${uuid}"/ background-color '#DFDBC3'
        gsettings set "${A}${uuid}"/ foreground-color '#000000'
        gsettings set "${A}${uuid}"/ default-size-rows 44
  done
  gsettings set org.gnome.desktop.interface cursor-blink false
fi

mkdir ~/bin 2> /dev/null

for FILE in ${FILES}
do
    rm -f ~/"${FILE}" 2> /dev/null
    # echo "${FILE}"
    ln ~/src/dotfiles/"${FILE}" ~/"${FILE}"
done


function userChrome () {
   for DIRS in "$@"
   do
        for POSSIBLE in ${DIRS}
        do
            if [[ -d "$POSSIBLE" ]]
            then
                echo "possible: ${POSSIBLE}"
                CHROME="${POSSIBLE}"/chrome
                mkdir "${CHROME}" 2> /dev/null

                FILE="${CHROME}"/userChrome.css
                rm "${FILE}" 2> /dev/null
                ln ~/src/dotfiles/FFuserChrome.css "${FILE}"

                STYLE='toolkit.legacyUserProfileCustomizations.stylesheets'
                PREFS=${POSSIBLE}/prefs.js
                if ! grep "${STYLE}" "${PREFS}" > /dev/null
                then
                    echo 'user_pref("'${STYLE}'", true);' >> "${PREFS}"
                fi

                if [[ "${POSSIBLE}" =~ .*[Tt]hunderbird.* ]]
                then
                    DIR="${POSSIBLE}"/webaccountMail/outlook.office365.com
                    mkdir -p "${DIR}" 2> /dev/null

                    FILE="${DIR}"/msgFilterRules.dat
                    rm "${FILE}" 2> /dev/null
                    ln ~/src/dotfiles/msgFilterRules.dat "${FILE}"
                fi
            fi
        done
    done
}

# sigh, see: https://superuser.com/questions/1507251/firefox-has-two-default-profiles-default-release-and-default-which-one-sho
FF=( ~/.mozilla/firefox/*.default-release ~/.mozilla/firefox/*.default ~/Library/Application\ Support/Firefox/Profiles/*.default-release ~/Library/Application\ Support/Firefox/Profiles/*.default )

userChrome "${FF[@]}"

TB=( ~/.thunderbird/*.default ~/.thunderbird/*.default.release ~/Library/Thunderbird/Profiles/*.default ~/Library/Thunderbird/Profiles/*.default.release )

userChrome "${TB[@]}"

