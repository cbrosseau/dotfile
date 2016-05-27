# Global Variables:
export GZIP=-9
export XZ_OPT=-9
export LESS='-F -r -X'
export EDITOR=vi
 
# Make sure all terminals save history:
shopt -s histappend
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
 
# Increase history size:
export HISTSIZE=10000000
export HISTFILESIZE=20000000
 
# Fancier time format when using the "time" command:
TIMEFORMAT=$'Elapsed Time: %0lR\nCPU Percents: %P%%'
 
# Use grep color features by default:
export GREP_OPTIONS='--color=auto'
 
# Activate Git Prompt Features:
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
 
# Change the window title of X terminals
case ${TERM} in
    xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
        PROMPT_COMMAND='echo -ne "\033]0;$(echo "${PWD/#$HOME/\~}"|sed s/workspace/…/g)$(__git_ps1 \(\%s\))\007"'
        trap 'echo -ne "\033]2;$(history 1 | sed "s/^[ ]*[0-9]*[ ]*//g")\007"' DEBUG
        ;;
    screen*)
        PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}$(__git_ps1 \(\%s\))\033\\"'
        ;;
esac
 
# Set colorful PS1 only on colorful terminals
if ${use_color} ; then
    if [[ ${EUID} == 0 ]] ; then
        PS1='\[\e[01;31m\]\u@\h\[\e[01;34m\]:\w\[\e[01;36m\]$(__git_ps1 "(%s)")\[\e[01;34m\]\$\[\e[00m\] '
    else
        PS1='\[\e[01;32m\]\u@\h\[\e[01;34m\]:\w\[\e[01;36m\]$(__git_ps1 "(%s)")\[\e[01;34m\]\$\[\e[00m\] '
    fi
else
    PS1='\u@\h:\w$(__git_ps1 "(%s)")\$ '
fi
