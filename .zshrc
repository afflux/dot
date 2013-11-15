# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=* r:|=*'
zstyle :compinstall filename '/home/k/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory extendedglob nomatch
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install

export WORDCHARS=''

# enable color support of ls and also add handy aliases

if [ -x /usr/bin/dircolors ]; then
    if [ -r ~/.dircolors  ]; then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

function color_test {   T='gYw';    echo -e "\n    def       40m   41m   42m   43m   44m   45m   46m   47m";   for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m'              '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m'              '  36m' '1;36m' '  37m' '1;37m';     do FG=${FGs// /};     echo -en " $FGs \033[$FG $T ";          for BG in 40m 41m 42m 43m 44m 45m 46m 47m;       do echo -en "$EINS \033[$FG\033[$BG $T \033[0m";     done; echo;   done; echo; };
export PYTHONDONTWRITEBYTECODE=1
export EMAIL=afflux@pentabarf.de

. $HOME/.local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
nocomments () {
egrep -v '^\s*'$1 $2 | egrep -v  '^ *$'
}

defaultstty () {
stty 2504:5:bf:8a3b:3:1c:7f:15:4:0:1:0:11:13:1a:ff:12:f:17:16:ff:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0
}

stty erase '^?'


autoload zkbd
if [[ -f ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE} ]]; then
	source ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}
else
	echo "WARNING: Keybindings may not be set correctly!"
	echo "Execute \`zkbd\` to create bindings."
fi

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
[[ -n ${key[C-Left]} ]] && bindkey "${key[C-Left]}" backward-word
[[ -n ${key[C-Right]} ]] && bindkey "${key[C-Right]}" forward-word

alias grl="git log --oneline"
