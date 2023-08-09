#! /usr/bin/env bash
# aliases and functions
# if non-interactive, don't write any output
if [[ -z "$PS1" ]]; then return; fi
if [[ "$BASH_VERSION" != "" && "$BASHRC" == "YES" ]]; then exit; fi
export BASHRC=YES
echo 'Starting in .bashrc'

if [[ -r ${HOME}/bin/bash-powerline.sh ]]
then
# shellcheck source=/Users/stevebeaty/bin/bash-powerline.sh
source "${HOME}"/bin/bash-powerline.sh
fi

if [[ -r /etc/bash_completion ]]
then
# shellcheck source=/etc/bash_completion
source /etc/bash_completion
fi

if [[ -r /usr/local/etc/bash_completion ]]
then
# shellcheck source=/usr/local/etc/bash_completion
source /usr/local/etc/bash_completion
fi

if [[ -r ${HOME}/.bashrc_private ]]
then
# shellcheck source=/Users/stevebeaty/.bashrc_private
    source "${HOME}"/.bashrc_private
fi

if [[ $(uname) == Darwin ]]; then
    function lshelper () {
        CLICOLOR_FORCE=1 /bin/ls -CFG "${@:1:1}" "${@:2}" | less -ERXF
    }
    alias o='open'
elif [[ $(uname) == Linux ]]; then
    function lshelper () {
        /bin/ls -CF --color=always "${@:1:1}" "${@:2}" | less -ERXF
    }
    alias o='xdg-open'
    # OS=$(head -1 /etc/issue | cut -d " " -f 1)
fi

alias fixff='cd ~/Library/Application\ Support/Firefox/Profiles/*.default/sessionstore-backups'
alias shrug='echo ¯\\\_\(ツ\)_/¯'
alias listening='netstat -anp tcp | grep "LISTEN"'
alias ls='lshelper'
alias la='lshelper -a'
alias ll='lshelper -l'
alias lla='lshelper -al'
alias lr='lshelper -R'
alias llr='lshelper -lR'
alias lt='lshelper -t'
alias llt='lshelper -lt'
alias git-color='git -c color.ui=always'
alias pr='git checkout -b drb80 && git commit app db test config public -m "drb80" && gh pr create'

function gitadddirectory () {
    git rm --cached "$*"
    rm -rf "$*/.git"
    git add "$*"
    git commit -am "Adding $*"
    git push
}

alias rmnonimage='rm $(file * | grep -v image | sed -e "s/:.*//")'
alias rmhtml='rm $(file * | grep HTML | sed -e "s/:.*//")'

function tolower () { echo "$*" | tr '[:upper:]' '[:lower:]'; }
function toupper () { echo "$*" | tr '[:lower:]' '[:upper:]'; }
function doc2pdf () {
    IFS=
    for i in "$@"
    do
        echo "$i"
        /Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to pdf "$i"
    done
}

alias mvncd='cd ../../../../../../..'
alias mvn='mvn -q'

alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dstopall='docker stop $(docker ps -aq)'
alias drmall='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'
alias drmiall='docker rmi -f $(docker images -q)'
alias drmvall='docker volume rm $(docker volume ls -q)'

alias potm='wget -q -O - http://www.moongiant.com/phase/today/ | grep "Moon Age" | sed -e "s/.*\"Moon Age:/Moon Age:/" -e "s/\".*//"'

alias green="find . -name '*.gif' -exec dirname '{}' ';' | uniq | xargs ~/bin/finder_colors.py green"

function best() { agrep -B "$@" /usr/share/dict/words; }

function unzipper () {
    for i in "$@"
    do
        unzip "$i"
        rm "$i"
        touch "$i"
    done
}

alias p='python3'
alias ut='python3 -m unittest'
alias be='bundle exec'
alias beep='echo -n ""'
alias utime='date -r'

alias rmthumbs="find -E . -regex '.*\.(jpg|gif|png)' -a -size -7k -exec rm '{}' ';'"

alias unquarantine='xattr -dr com.apple.quarantine'

function cd () { builtin cd "$*" && lshelper .; }
function pd () {
    if [[ $# == 0 ]]
    then
        pushd || return
    else
        pushd "$*" || return
    fi
}
function deepgrep () { find . -type f -not -name '*\.svn*' -not -name '*,v' -exec grep -I "$*" '{}' ';' -print; }
function deepgrepi () { find . -type f -not -name '*\.svn*' -not -name '*,v' -exec grep -i -I "$*" '{}' ';' -print; }

function rmemptydir () { find "$*" -depth -type d -empty -exec rmdir '{}' ';' ; }

# ## front, %% end
function m4a2mp3() {
    for i in "$@"
    do
        ffmpeg -i "$i" "${i%%.m4a}.mp3"
    done
}

alias ntpstat='ntpdc -c peers'
alias epoch='date -r'
alias ch='choice'
alias randompass='openssl rand -base64 12'

function addcom () {
    for i in "$@"
    do
        echo "$i"
        git add "$i" && git commit -m 'initial' "$i"
    done
}

alias branch='git branch'
alias co='git checkout'
alias commit='git commit'
alias merge='git merge'
alias pull='git pull'
alias push='git push'
alias status='git status'
alias git_push_this_branch='git push origin $(git branch --show-current)'
function git_delete_branch () {
    git branch -d "$1" && git push origin --delete "$1"
}

function md { showdown makehtml -i "$1" -o "${1%%.md}".html --tables --simplifiedAutoLink; }

function timer { (sleep $((60 * $*)); echo -ne \\a\\a\\a\\a) & }
function minutes { (sleep $((60 * $*)); echo -ne \\a\\a\\a\\a) & }
function seconds { (sleep "$@"; echo -ne \\a\\a\\a\\a) & }
function docxgrep () {
    for i in "${@:2}"
    do
        if unzip -p "$i" | sed -e 's/<[^>]\{1,\}>//g; s/[^[:print:]]\{1,\}//g' | grep "$1" > /dev/null
        then
            echo "$i"
        fi
    done
}

export EDITOR=vi
export PYTHONSTARTUP=~/.pythonrc

function sc () {
    /Users/stevebeaty/src/schemacrawler-16.10.1-distribution/_schemacrawler/schemacrawler.sh --no-info --command=schema --database="$1" --info-level=standard --server=sqlite --output-format=png --output-file=schema.png
}
alias rss='ps aux | sort -n -k 4'
alias gmt='zdump gmt'
alias phil='zdump Asia/Manila'
alias it='zdump Europe/Rome'
alias c='clear'
alias cp='cp -i'
function gifinfo () {
    giftopnm -verbose "$@" > /dev/null
}
alias gv='ghostview -magstep -4'
alias h='history'
alias j='jobs'
function jpginfo () {
    djpeg -fast -gif "$@" | giftopnm -verbose > /dev/null
}
alias m='less -ReF'
alias more='less -ReF'
alias mv='mv -i'
alias now='date "+%Y%m%d%H%M%S"'
alias t='tail'
alias today='date "+%Y-%m-%d"'

function shuf () {
    sort -R "$@" | head -n 1
}

alias prsst='python3 "${HOME}"/src/PRSST/prsst/main.py &'

alias stealth='sudo ifconfig en0 lladdr 00:11:22:33:44:55'
alias unstealth='sudo ifconfig en1 lladdr a4:5e:60:e8:b9:05'

alias rrmyseeds='bundle install && yarn install --check-files && rails db:migrate && \cp -f ~/seeds.rb db && rails db:seed && rails server'
alias rrseedless='bundle install && yarn install --check-files && rails db:migrate && rails db:seed && rails server'

alias cleanrails='find . -depth -name node_modules -o -name cache -exec rm -rf "{}" ";"'
alias railspull='git pull git@github.com:msu-denver-cs/${PWD##*/}.git'

alias ramdisk='mkdir /tmp/ramdisk && chmod 777 /tmp/ramdisk && sudo mount -t tmpfs -o size=1G myramdisk /tmp/ramdisk'

alias killspring='ps ax | grep spring | colrm 8 | xargs kill'

if [[ -x "$(command -v rbenv)" ]]
then
    eval "$(rbenv init -)"
fi

# added by travis gem
# shellcheck source=/Users/beatys/.travis/travis.sh
[ -f /Users/beatys/.travis/travis.sh ] && source /Users/beatys/.travis/travis.sh

export NVM_DIR="$HOME/.nvm"
# shellcheck source=/Users/stevebeaty/.nvm/nvm.sh
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# shellcheck source=/Users/stevebeaty/.nvm/bash_completion
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# vim: wm=0
echo "Done with .bashrc"
