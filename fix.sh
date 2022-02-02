#! /bin/bash

# dconf watch /

shopt -s nullglob

# X window manager etc. settings
function WMsettings () {
    UUIDS=$(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "',")
    PALETTE="['rgb(7,54,66)', 'rgb(0,0,0)', 'rgb(85,85,85)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"
    A='org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:'

    # kinda 2-d array
    a=(cursor-blink-mode background-color foreground-color palette default-size-rows)
    b=(off '#DFDBC3' '#000000' "${PALETTE}" 44)
    for UUID in ${UUIDS}
    do
        length=${#a[@]}
        for (( i=0; i<length; i++ ))
        do
            gsettings set "${A}${UUID}"/ "${a[$i]}" "${b[$i]}"
        done
    done
    gsettings set org.gnome.desktop.interface cursor-blink false
    gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

    WM=org.cinnamon.desktop.keybindings.wm
    a=( close minimize move-to-workspace-right move-to-workspace-left )
    b=( "['<Super>q']" "['<Super>m', '<Super>h']" "['<Super>Right']" "['<Super>Left']" )
    length=${#a[@]}
    for (( i=0; i<length; i++ ))
    do
        gsettings set "${WM}" "${a[$i]}" "${b[$i]}"
    done
}

function dotsNbins () {
    mkdir ~/bin 2> /dev/null

    FILES=".vimrc .gtkrc-2.0 .prsst.yml .bash_profile .bashrc .signatures .screenrc bin/*"

    for FILE in ${FILES}
    do
        rm -f ~/"${FILE}" 2> /dev/null
        ln ~/src/dotfiles/"${FILE}" ~/"${FILE}"
    done
}

function autostarts () {
    mkdir -p ~/.config/autostart 2> /dev/null

    for FILE in .config/autostart/*
    do
        rm -f ~/"${FILE}" 2> /dev/null
        ln ~/src/dotfiles/"${FILE}" ~/"${FILE}"
    done
}

function mozilla_prefs () {
    if ! grep "${1}" "${2}" > /dev/null
    then
        echo 'user_pref("'"${1}"'", "'"${3}"'");' >> "${2}"
    fi
}

function userChrome () {
   for DIR in "${@}"
   do
       echo "${DIR}"

       CHROME="${DIR}"/chrome
       mkdir "${CHROME}" 2> /dev/null

       PREFS=${DIR}/prefs.js
       STYLE='toolkit.legacyUserProfileCustomizations.stylesheets'
       VALUE=true
       mozilla_prefs "${STYLE}" "${PREFS}" "${VALUE}"

       FILE="${CHROME}"/userChrome.css
       rm "${FILE}" 2> /dev/null
       if [[ "${DIR}" =~ .*[Tt]hunderbird.* ]]
       then
           ln ~/src/dotfiles/TBuserChrome.css "${FILE}"
        else
           ln ~/src/dotfiles/FFuserChrome.css "${FILE}"

           STYLE='browser.backspace_action'
           VALUE=2
           mozilla_prefs "${STYLE}" "${PREFS}" "${VALUE}"
        fi
    done
}

function outlook () {
    for DIR in "${@}"
    do
        echo "${DIR}"

        FILE="${DIR}"/msgFilterRules.dat
        rm "${FILE}" 2> /dev/null
        ln ~/src/dotfiles/msgFilterRules.dat "${FILE}"
    done

}

# sigh, see: https://superuser.com/questions/1507251/firefox-has-two-default-profiles-default-release-and-default-which-one-sho
FF=("${HOME}"/.mozilla/firefox/*.default* ${HOME}/Library/Application\ Support/Firefox/Profiles/*.default*)
userChrome "${FF[@]}"

TB=("${HOME}"/.thunderbird/*.default* "${HOME}"/Library/Thunderbird/Profiles/*.default*)
userChrome "${TB[@]}"

OL=("${HOME}"/.thunderbird/*.default*/webaccountMail/outlook.office365*.com "${HOME}"/Library/Thunderbird/Profiles/*.default*/webaccountMail/outlook.office365*.com)
outlook "${OL[@]}"

if [[ $(uname) == Linux ]]
then
    WMSettings
fi

dotsNbins
autostarts

# vim: wm=0
