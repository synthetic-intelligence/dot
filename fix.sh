#! /bin/bash

# dconf watch /

FILES=".vimrc .gtkrc-2.0 .prsst.yml .bash_profile .bashrc .signatures .screenrc bin/*"

if [[ $(uname) == Linux ]]
then
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

    WM=org.cinnamon.desktop.keybindings.wm
    a=( close minimize move-to-workspace-right move-to-workspace-left )
    b=( "['<Super>q']" "['<Super>m', '<Super>h']" "['<Super>Right']" "['<Super>Left']" )
    length=${#a[@]}
    for (( i=0; i<length; i++ ))
    do
        gsettings set "${WM}" "${a[$i]}" "${b[$i]}"
    done
fi

mkdir ~/bin 2> /dev/null

for FILE in ${FILES}
do
    rm -f ~/"${FILE}" 2> /dev/null
    # echo "${FILE}"
    ln ~/src/dotfiles/"${FILE}" ~/"${FILE}"
done

function mozilla_prefs () {
    if ! grep "${1}" "${2}" > /dev/null
    then
        echo 'user_pref("'"${1}"'", "'"${3}"'");' >> "${2}"
    fi
}

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

                PREFS=${POSSIBLE}/prefs.js
                STYLE='toolkit.legacyUserProfileCustomizations.stylesheets'
                VALUE=true
                mozilla_prefs "${STYLE}" "${PREFS}" "${VALUE}"

                STYLE='browser.backspace_action'
                VALUE=2
                mozilla_prefs "${STYLE}" "${PREFS}" "${VALUE}"

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

# gsettings get org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ palette

# foo="['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)', 'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)', 'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)', 'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)', 'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)', 'rgb(253,246,227)']"


# vim: wm=0
