alias пше="git"
alias cbranch='git rev-parse --abbrev-ref HEAD'
alias brcls='git branch | grep -v -E "master|dev" | xargs git branch -D'
alias xbrcls='git branch -l | grep -v -E "main|master|dev" | xargs git branch -D'

