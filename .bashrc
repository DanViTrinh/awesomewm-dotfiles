#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/Dan/MATLAB/R2022b/bin/glnxa64
# cant get this to work 
#export LD_LIBRARY_PATH=/home/Dan/MATLAB/R2022b/bin/glnxa64
