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
setopt appendhistory extendedglob nomatch magic_equal_subst interactivecomments
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

function color_test {
	T='gYw';
	echo -e "\n    def       40m   41m   42m   43m   44m   45m   46m   47m  100m  101m  102m  103m  104m  105m  106m  107m";
	for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m' '  90m' '1;90m' '  91m' '1;91m' '  92m' '1;92m' '  93m' '1;93m' '  94m' '1;94m' '  95m' '1;95m' '  96m' '1;96m' '  97m' '1;97m' ; do
		FG=${FGs// /};
		echo -en " $FGs \033[$FG $T ";
		for BG in 40m 41m 42m 43m 44m 45m 46m 47m 100m 101m 102m 103m 104m 105m 106m 107m; do
			echo -en " \033[$FG\033[$BG $T \033[0m";
		done;
		echo;
	done;
	echo;
};
export PYTHONDONTWRITEBYTECODE=1
export EMAIL=afflux@pentabarf.de

export VIRTUAL_ENV_DISABLE_PROMPT=1

if [[ -e ~/.zsh-show-hostname || -n "$SSH_CLIENT" ]] ; then
  zsh_show_hostname=1
fi


my-prompt() {
  local sp="\u00a0" sub="\ue0b0" lock="\ue0a2"

  # ssh host is white (15) on yellow (3), with lock symbol
  [[ -n "$zsh_show_hostname" ]] && echo -n "%{%K{3}%F{15}%}$sp$lock$sp%M$sp%{%F{3}%}"

  # username has light blueish (12) background, or red if elevated
  echo -n "%{%(!.%K{160}.%K{12})%}"
  [[ -n "$zsh_show_hostname" ]] && echo -n "$sub"
  echo -n "%{%B%F{231}%}$sp%n$sp%{%b%(!.%F{160}.%F{12})%}"

  # virtual env gets dark blueish background (4)
  [[ -n "$VIRTUAL_ENV" ]] && echo -n "%{%K{4}%}$sub%{%F{231}%}$sp(e)$sp$(basename $VIRTUAL_ENV)$sp%{%F{4}%}"

  # CWD gets gray background (252 on 240)
  echo -n "%{%K{240}%}$sub%{%F{252}%}$sp%~$sp%{%F{240}%}"

  # return code gets dark red background (52)
  echo -n "%(?..%{%K{52}%}$sub%{%F{231}%}$sp✘$sp%?$sp%{%F{52}%})"

  # jobs are white (15) on yellow (3)
  echo -n "%(1j.%{%K{3}%}$sub%{%F{15}%}$sp%j$sp%{%F{3}%}.)"

  echo -n "%{%k%}$sub%{%f%}$sp"
}

my-rprompt() {
  local sp="\u00a0" sub="\ue0b2" samesub="\ue0b3" lock="\ue0a2"
  local gitstatus=$(git status --porcelain=v2 --branch 2> /dev/null)
  if [[ -n "$gitstatus" ]]; then
    branch=$(awk '/^# branch.head / { print $3 }' <<<$gitstatus)
    isdirty=$(awk '!/^#/ { count++ } END { print count }' <<<$gitstatus)
    numstashs=$(git stash list 2>/dev/null | wc -l)
  fi

  if [[ -z "$branch" || "$numstashs" -ne 0 || "$isdirty" -eq 0 ]] ; then
    # gray
    nextbg=236
  else
    # yellow
    nextbg=3
  fi

  echo -n "%{%F{$nextbg}%}$sub%{%K{$nextbg}%}$sp"

  if [[ "$numstashs" -ne 0 ]] ; then
    echo -n "%{%F{3}%}ST$sp$numstashs$sp"
    if [ "$isdirty" -eq 0 ] ; then
      echo -n "%{%F{250}%}$samesub$sp"
    else
      echo -n "%{%F{3}%}$sub%{%K{3}%}$sp"
    fi
  fi

  if [[ -n "$branch" ]] ; then
    if [ "$isdirty" -eq 0 ] ; then
      echo -n "%{%F{250}%}$branch$sp$samesub$sp"
    else
      echo -n "%{%F{0}%}$branch$sp%{%F{236}%K{3}%}$sub%{%K{236}%}$sp"
    fi
  fi

  echo -n "%{%F{250}%}%*$sp%f%k"
}
setopt PROMPT_SUBST
PROMPT='$(my-prompt)'
if [[ -e ~/.zsh-no-git ]] ; then
  sub=$(echo -n "\ue0b2")
  sp=$(echo -n "\u00a0")
  RPROMPT="%{%F{236}%}$sub%K{236}%F{250}$sp%*$sp%f%k"
else
  RPROMPT='$(my-rprompt)'
fi

nocomments () {
egrep -v '^\s*'$1 $2 | egrep -v  '^\s*$'
}

defaultstty () {
stty 2504:5:bf:8a3b:3:1c:7f:15:4:0:1:0:11:13:1a:ff:12:f:17:16:ff:0:0:0:0:0:0:0:0:0:0:0:0:0:0:0
}

stty erase '^?'

bindkey \^U backward-kill-line

autoload zkbd
if [[ -f ~/.zkbd/$TERM ]]; then
	source ~/.zkbd/$TERM
else
	echo "WARNING: Keybindings may not be set correctly!"
	echo "path is: ~/.zkbd/$TERM-${DISPLAY:-$VENDOR-$OSTYPE}"
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

alias grl="git log --oneline --graph --decorate"
hashssh () {
    for pk in /etc/ssh/ssh_host_*_key.pub; do
        mech=${pk%_key.pub}
        mech=${mech#/etc/ssh/ssh_host_}
        B="$(awk '{print $2}' "$pk")"
        if [ -z "$B" ] ; then
            continue
        fi
        for hash in sha256 md5; do
            H="$(base64 -d <<<"$B" | ${hash}sum -b | awk '{print $1}')" ;
            echo -e "\n${mech} ${hash}\n==============";
            # hex
            fold -w2 <<<"$H" | paste -sd':' -
            # base64
            echo ${(U)hash}:$(xxd -r -p <<<"$H" | base64 | sed 's/=\+$//')
        done
    done
}

# disable flow control on stty, so CTRL-S can be used
stty -ixon
# freeze TTY, so shell will restore after processes went mad. stty will stop working!
ttyctl -f

unset SSH_AGENT_PID
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
precmd () { print -Pn "\e]0;$PWD\a" }

[ -r ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_AUTOSUGGEST_USE_ASYNC=1
[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
