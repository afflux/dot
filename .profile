# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022
# include .bashrc if it exists

if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		case $- in
		*i*)
			. "$HOME/.bashrc"
			;;
		esac
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export EDITOR=vim

OS=`uname -s`

if [ x$OS = xLinux ] ; then
    if [ -d "$HOME/.local/bin" ] ; then
        PATH="$HOME/.local/bin:$PATH"
    fi

    if [ -d "$HOME/py2.7/bin" ] ; then
        PATH="$HOME/py2.7/bin:$PATH"
        PYTHONHOME="$HOME/py2.7"
        export PYTHONHOME
    fi
fi
