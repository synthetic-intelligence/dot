if [ -z "$PS1" ]; then return; fi
if [ "$BASH_PROFILE" == "YES" ]; then return; fi
BASH_PROFILE=YES

if [ -e ~/.bashrc ]; then . ~/.bashrc; fi
if [ -e ~/bin/bash-powerline.sh ]; then . ~/bin/bash-powerline.sh; fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

umask 077

export FIGNORE=".DS_Store"
export GLOBIGNORE=".DS_Store"
export PS1='\u@\h->\W\$ '
export EDITOR=vi

export ARCH=`uname -p`

possible="$PATH \
    $HOME/bin \
    $HOME/.rbenv/shims \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/bin \
    /bin \
    /sbin \
    /usr/sbin \
    /usr/bin/X11 \
    /opt/local/bin \
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
    if [ "${PATH%%:$i*}" == "$PATH" ]
    then
        if [ -d $i ]
        then
             echo "adding $i"
            if [ "$PATH" != "" ]
            then
                PATH=$PATH:$i
            else
                PATH=$i
            fi
        fi
    fi

    # remove the last directory and add "man"
    manpath=${i%/*}/man

    if [ "${MANPATH%%$manpath*}" == "$MANPATH" ]
    then
        if [ -d $manpath ]
        then
            MANPATH=$MANPATH:$manpath
        fi
    fi

done

for i in $extraman
do
    if [ "${MANPATH%%$i*}" == "$MANPATH" ]
    then
        if [ -d $i ]
        then
            MANPATH=$MANPATH:$i
        fi
    fi
done

eval "$(rbenv init -)"

