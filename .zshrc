##.zshrc by samurai ##

##preexec from richo, then modded by samurai
##TODO - Add all commands that shouldn't update title in here.
##TODO  - Have some STATIC keyword to make the title immutable.
function preexec()
{ 
	case $1 in
		"ls"*|"cp"*|"mv"*|"cd"*|"echo"*|"wiki"*|"screen"*|"dig"*|"rm"*)
			return ;;
		# Catch kill early
		"clear"*)
			   arg="zsh";;
		"kill "*)
			arg=$(echo $1 | awk '{print $NF}');;
		"ctags"*|"killall"*|"screen"*)
			return ;;
		"man"*)
			arg=$1;;
		# For Source control I want the whole line, I think...
		"svn"*|"git"*|"hg"*|"cvs"*)
			arg=$1;;
		"make"*)
			arg=$(pwd | grep -o "[^/]*/[^/]*$");;
		# Webby stuffs
		"lynx"*|"links"*)
			arg=$(echo $1 | sed -r -e 's/^(lynx|links) (http[s]?:\/\/)?(www\.)?//' -e 's/\/.*$//');;
		"su"*)
			arg="!root!";;
		##I'd like to know editors vs scripts being run
		"nano"*|"vi"*|"vim"*)
			arg="(e)$(echo $1 | awk '{print $NF}')";;
		##Same sort of thing for scripts
		"sh"*|"bash"*|"zsh"*|"python"*|"perl"*)
			arg="(s)$(echo $1 | awk '{print $NF}')";;
		*)
			arg=$(echo $1 | awk '{print $NF}');;
	esac

	if [ ! -z $INSCREEN ] ; then
		echo -ne "\033k$arg\033\\"
	fi
} ## /prexec


function precmd()
{
	if [ ! -z $INSCREEN ] ; then
		echo -ne "\033kzsh\033\\"
	fi
} ## /postexec


## aliases
alias ..='cd ..'
alias ...='cd ../..'
alias nano='nano -$'
alias ll='ls -al'
#alias ls='ls --color=auto ' ##this breaks on the mac...
alias grep='grep --color'
alias ssh-rogue='ssh -p 8022 drewid@storm.psych0tik.net'

##OSX's svn sucks. i've got a better one in prefix :D
if [ $HOST = "magneto.local" ] ; then
	alias svn='~/Gentoo/usr/bin/svn'
fi


##completition
zstyle ':completion:*' special-dirs true
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*:processes' command 'ps -axw'
zstyle ':completion:*:processes-names' command 'ps -awxho command'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' hosts on

##other settings
setopt CORRECT			# command CORRECTION
setopt EXTENDED_HISTORY		# puts timestamps in the history
setopt MENUCOMPLETE
setopt ALL_EXPORT
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent 
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
setopt   nobanghist 
setopt interactivecomments
setopt noclobber  ##this might piss me off, for now we'll see how it works out
unsetopt bgnice autoparamslash


## vars
export EDITOR=nano
export PAGER='less'
export SHELL='zsh'
##path
PATH="/bin/:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin/:$PATH"


##mac-tacular keybindings
bindkey "^[[H" 	beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^f" 	forward-word
bindkey "^b"	backward-word

##prompts
PS1="[$PR_MAGENTA%n$PR_NO_COLOR@$PR_GREEN%U%m%u$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR]%(!.#.$) "
##if we're in prefix, let us know (mostly for magneto)
if [ ! -z $INPREFIX ] ; then
	PS1="[$PR_MAGENTA%n$PR_NO_COLOR@{prefix}$PR_GREEN%U%m%u$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR]%(!.#.$) ";
fi
RPS1="$PR_MAGENTA(%D{%m-%d %H:%M})$PR_NO_COLOR"

autoload -U compinit
compinit
