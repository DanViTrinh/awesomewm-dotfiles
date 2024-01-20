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

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/Dan/.micromamba/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/Dan/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/Dan/micromamba/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/Dan/micromamba/etc/profile.d/conda.sh" ]; then
        . "/home/Dan/micromamba/etc/profile.d/conda.sh"
    else
        export PATH="/home/Dan/micromamba/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

