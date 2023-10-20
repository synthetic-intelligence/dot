#! /usr/bin/env bash
if [[ -z "$PS1" ]]; then return; fi
if [[ "$BASH_PROFILE" == "YES" ]]; then return; fi
BASH_PROFILE=YES
echo "Starting in .bash_profile"

# shellcheck source=/Users/stevebeaty/.bashrc
if [[ -e ~/.bashrc ]]; then . ~/.bashrc; fi

umask 077

export PS1='\u@\h->\W\$ '
export FIGNORE=".DS_Store"
export GLOBIGNORE=".DS_Store"
export EDITOR=vi
export TK_SILENCE_DEPRECATION=1

ARCH=$(/usr/bin/uname -p)
export ARCH

possible="$HOME/bin \
    $HOME/.rbenv/shims \
    /opt/local/bin \
    /opt/homebrew/bin \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/bin \
    /bin \
    /sbin \
    /usr/sbin \
    /usr/bin/X11 \
    /local/sbin \
    /etc/alternatives \
    /Applications/Docker.app/Contents/Resources/bin \
    "

extraman="/usr/share/man"

echo "Building PATH and MANPATH"
export PATH=""
export MANPATH=""
for i in $possible
do
    # When  the  == and != operators are used, the string to the right
    # of the operator is considered a pattern

    # is this a new path?
    if [[ "${PATH%%:"$i"*}" == "$PATH" ]]
    then
        if [[ -d $i ]]
        then
             echo "adding $i"
            if [[ "$PATH" != "" ]]
            then
                PATH=$PATH:$i
            else
                PATH=$i
            fi
        fi
    fi

    # remove the last directory and add "man"
    manpath=${i%/*}/man

    if [[ "${MANPATH%%"$manpath"*}" == "$MANPATH" ]]
    then
        if [[ -d $manpath ]]
        then
            MANPATH=$MANPATH:$manpath
        fi
    fi

done

for i in $extraman
do
    if [[ "${MANPATH%%"$i"*}" == "$MANPATH" ]]
    then
        if [[ -d $i ]]
        then
            MANPATH=$MANPATH:$i
        fi
    fi
done

if [[ -x "$(command -v rbenv)" ]]
then
    eval "$(rbenv init -)"
fi

echo "Done with .bash_profile"
