# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# ranger alias
alias ranger='ranger --choosedir=$HOME/rangerdir; LASTDIR=`cat $HOME/rangerdir`; cd "$LASTDIR"'
alias r='ranger --choosedir=$HOME/rangerdir; LASTDIR=`cat $HOME/rangerdir`; cd "$LASTDIR"'
alias rr='sudo ranger --choosedir=$HOME/rangerdir; LASTDIR=`cat $HOME/rangerdir`; cd "$LASTDIR"'

#one letter things
alias c='clear'

alias gi='grep -ri --exclude-dir=node_modules/ --exclude-dir=.git/'
alias gI='grep -r --exclude-dir=node_modules/ --exclude-dir=.git/'

alias ga='git add'
alias gs='git status'
alias gb='git branch'
alias gc='git commit -m'
alias gp='git push'
alias gt='git log --oneline --all --graph'
alias gco='git checkout'

#for fun
alias pas='sudo pacman -S'
alias par='sudo pacman -Rs'

# navigation stuff
alias ..="cd .."
alias ..2="cd ../.."
alias ..3="cd ../../.."
alias ..4="cd ../../../.."
alias ..5="cd ../../../../.."
alias ..6="cd ../../../../../.."
alias ..7="cd ../../../../../../.."

######################################
#virtual environments
######################################
#alias workon-soop='source /home/j/.myvirtualenvs/soop/bin/activate'


#fast bash and vim rc editing
alias v='nvim '
alias brc='nvim ~/.bashrc'
alias vrc='nvim ~/.config/nvim/init.vim'


#vpn connections
#alias sfonion="ssh -o IdentitiesOnly=yes -i ~/.ssh/onion_rsa root@165.227.20.37"
#alias ovhonion="ssh arch@167.114.67.167"

alias xsel="xsel -ib"
alias update='reflector -l 100 -c US -f 6 | sudo tee /etc/pacman.d/mirrorlist; sudo pacman -Syu'
alias fa='faas-cli '
alias dockerstop="docker ps | grep -v CONTAINER | awk '{ print $1 }' | xargs docker container stop; docker container prune"
alias sshp="ssh -o PreferredAuthentications=password"
