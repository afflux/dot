#!/bin/sh

# we prefer zsh in interactive shell sessions. This bashrc will workaround 
# environments where we can't change the login shell.

case $- in 
*i*)
OS=`uname -s`

if [ x$OS != xSunOS ] ; then
        if [ -x "`which zsh`" ] ; then
                exec zsh --login
        fi
fi
;;
esac

