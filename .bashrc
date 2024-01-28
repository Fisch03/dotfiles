#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias dots_configure='python ~/.config/ags/scripts/configure.py'

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

wal -q -f ~/.config/ags/colors.json
