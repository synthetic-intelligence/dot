# aliases and functions
if [ -z "$PS1" ]; then return; fi
if [ "$BASHRC" == "YES" ]; then return; fi
export BASHRC=YES

if [ -r /etc/bash_completion ]; then . /etc/bash_completion; fi
if [ -r ~/.bashrc_private ]; then . ~/.bashrc_private; fi

if [ `uname` == Darwin ]; then
    function lshelper() {
        CLICOLOR_FORCE=1 /bin/ls -GFC ${*:1:1} ${*:2} | more -R
    }
    alias o='open'
elif [ `uname` == Linux ]; then
    function lshelper() {
        /bin/ls -F --color=always ${*:1:1} ${*:2} | more -R
    }
    alias o='xdg-open $*'
    alias listening='netstat --tcp --listening'
    OS=`head -1 /etc/issue | cut -d " " -f 1`
    if [ $OS == Ubuntu ]; then
        alias list='dpkg --list'
        alias update='sudo apt-get update'
        alias pfind="apt-cache showpkg"
        alias pinstall="sudo apt-get install"
    elif [ $OS == CentOS ]; then
        alias update='sudo yum update'
        alias pfind="yum info"
        alias pinstall="sudo yum install"
        alias plist="rpm -qlp"
        alias pinfo="rpm -qip"
        alias punpack="(rpm2cpio | cpio -i --make-directories) <"
        alias pinstalled="rpm -qai"
        alias perase="rpm -e"
    fi
fi

alias ls='lshelper'
alias la='lshelper -a'
alias ll='lshelper -l'
alias lla='lshelper -al'
alias lr='lshelper -R'
alias llr='lshelper -lR'
alias lt='lshelper -t'
alias llt='lshelper -lt'

function tolower () { echo "$*" | tr '[:upper:]' '[:lower:]'; }
function toupper () { echo "$*" | tr '[:lower:]' '[:upper:]'; }
function doc2pdf () {
    IFS=
    for i in $*
    do
        echo "$i"
        /Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to pdf "$i"
    done
}

alias mvncd='cd ../../../../../../..'
alias mvn='mvn -q'

alias d='docker'
alias dstopall='docker stop $(docker ps -aq)'
alias drmall='docker rm $(docker ps -aq)'
alias drmiall='docker rmi $(docker ps -aq)'

alias potm='wget -q -O - http://www.moongiant.com/phase/today/ | grep "Moon Age" | sed -e "s/.*\"Moon Age:/Moon Age:/" -e "s/\".*//"'

alias green="find . -name '*.gif' -exec dirname '{}' ';' | uniq | xargs ~/bin/finder_colors.py green"

function best() { agrep -B $@ /usr/share/dict/words; }

function unzipper ()
{
    for i in $@
    do
        unzip $i
        rm $i
        touch $i
    done
}

alias p=python3
alias ut='python3 -m unittest'
alias be='bundle exec'
alias beep='echo -n ""'
alias utime='date -r'

alias mcd='cd ../../../../../../..'

alias rmthumbs="find -E . -regex '.*\.(jpg|gif|png)' -a -size -7k -exec rm '{}' ';'"

alias unquarantine='xattr -dr com.apple.quarantine'

function cd () { builtin cd "$*"; $LS; }
function pd () { if [[ $# == 0 ]]; then pushd; else pushd $*; fi; $LS; }
function deepgrep () { find . -type f -not -name '*\.svn*' -not -name '*,v' -exec grep -I "$*" '{}' ';' -print; }
function deepgrepi () { find . -type f -not -name '*\.svn*' -not -name '*,v' -exec grep -i -I "$*" '{}' ';' -print; }

function rmemptydir () { find $* -depth -type d -empty -exec rmdir '{}' ';' ; }

# ## front, %% end
function m4a2mp3() {
    for i in "$@"
    do
        ffmpeg -i "$i" "${i%%.m4a}.mp3"
    done
}

alias ntpstat='ntpdc -c peers'
alias epoch='date -r'
alias ch=choice
alias randompass='openssl rand -base64 12'

function addcom () {
    for i in $*
    do
        echo "$i"
        git add "$i" && git commit -m 'initial' "$i"
    done
}

alias branch="git branch"
alias co="git checkout"
alias commit="git commit"
alias merge="git merge"
alias pull="git pull"
alias push="git push"
alias status="git status"

function md { showdown makehtml -i $1 -o ${1%%.md}.html --tables --simplifiedAutoLink; }

function timer { (sleep $((60 * $*)); echo -ne \\a) & }
function minutes { (sleep $((60 * $*)); echo -ne \\a) & }
function seconds { (sleep $*; echo -ne \\a) & }
function docxgrep () {
    for i in "${@:2}"
    do
        if unzip -p "$i" | sed -e 's/<[^>]\{1,\}>//g; s/[^[:print:]]\{1,\}//g' | grep "$1" > /dev/null
        then
            echo $i
        fi
    done
}

export EDITOR=vi
export PYTHONSTARTUP=~/.pythonrc

alias rss="ps aux | sort -n -k 4"
alias gmt="zdump gmt"
alias phil='zdump Asia/Manila'
alias it='zdump Europe/Rome'
alias c='clear'
alias cp='cp -i'
alias gifinfo='giftopnm -verbose $* > /dev/null'
alias gv='ghostview -magstep -4'
alias h='history'
alias j='jobs'
alias jpginfo='djpeg -fast -gif $* | giftopnm -verbose > /dev/null'
alias m='more'
alias mv='mv -i'
alias now='date "+%Y%m%d%H%M%S"'
alias t='tail'
alias today='date "+%Y-%m-%d"'
