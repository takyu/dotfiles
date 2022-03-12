# -------------------------------------------------------------------------------------------- #
# Display on the terminal when the .zshrc is started loading
# -------------------------------------------------------------------------------------------- #
display_init()
{
	terminal="$(tty | tr -d '/dev/')"

	if [ "$terminal" = "ttys000" ] ; then
		echo -e '\033];Main\007'
		neofetch && neofetch --clean
		echo "Now, loading .zshrc file on \033[36m$terminal\033[m( Main Terminal ).."
	else
		env="$(uname -smnr)"
		zsh="$(zsh --version)"

		echo -ne '\033];Sub\007'
		echo "\033[36m$env $zsh\033[m"
		echo "Now, loading .zshrc file on \033[36m$terminal\033[m( Sub Terminal ).."
	fi
}
display_init


# -------------------------------------------------------------------------------------------- #
# Read source files
# -------------------------------------------------------------------------------------------- #

# Private functions
source $HOME/dotfiles/.zsh/private_functions.sh

# Private functions for prompt
source $HOME/dotfiles/.zsh/private_functions_for_prompt.sh

# Function to update everything in brew.
source $HOME/dotfiles/.zsh/configure_update_mas_n_brew.sh

# Function to open the browser in Chrome and Brave from the terminal.
source $HOME/dotfiles/.zsh/search_google.sh

# Functions related to the start of study and end of study times and time of study
# Functions for wake-up time, bedtime, and sleep time
source $HOME/dotfiles/.zsh/set_time.sh

#
# Function to ask option of command 'snowmachine'
# It is terminal is to snow..
# https://github.com/sontek/snowmachine
#
source $HOME/dotfiles/.zsh/ask_opt_snowmachine.sh

# A plugin that color-codes your input to make sure it is correct
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# A plugin that searches for previously executed commands and completes them
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh


# -------------------------------------------------------------------------------------------- #
# Terminal settings
# -------------------------------------------------------------------------------------------- #

# disable the per-terminal-session command history
SHELL_SESSION_HISTORY=0

#
# Automatic recompilation of .zshrc
# Compare the updated dates of '.zshrc' file and '.zshrc.zwc' it.
#
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
	zcompile ~/.zshrc
fi

# A plugin that make completion more powerful
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

#
# "autoload" will load the built-in functions in $FPATH.
# "vcs_info" is a function to get information from the version control system.
#
#autoload -Uz vcs_info

# Configure the git status to be displayed in PROMPT
#zstyle ':vcs_info:git:*' check-for-changes true
#zstyle ':vcs_info:git:*' stagedstr "%F{red}!"
#zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
#zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
#zstyle ':vcs_info:*' actionformats '[%b|%a]'

#
# "precmd () {}" is a function that is executed every time the prompt is displayed.
# By executing vcs_info, it rewrites the contents of the variable "vcs_info_msg_0_"
# to the latest every time the prompt is displayed.
#
#precmd () { vcs_info }

# "setopt prompt_subst" will expand the variable in the PROMPT variable.
setopt prompt_subst

# "setopt transient_rprompt" always remains only the last line rprompt
setopt transient_rprompt

# Configure the time to be displayed every second in RPROMPT
export TMOUT=1
TRAPALRM()
{
	zle reset-prompt
}

# Customize of prompt (left prompt)
PROMPT='%F{white}@%n%f%b %F{blue}%~%f `_display_git_current_branch`
🐧 '

# Customize of rpropmpt (right propmpt)
RPROMPT='`_display_battery_amount` %F{white}%D{%y-%m-%d %a %H:%M:%S}%f'

# Variables for coloring man
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[01;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[01;32m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[45;93m'
export LESS_TERMCAP_se=$'\e[0m'

# Configure about beep
setopt no_beep
setopt nolistbeep
setopt no_hist_beep

# Configure about zsh history
HISTFILE=~/.zsh_history
SAVEHIST=1000000
HISTSIZE=1000000
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt inc_append_history
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_reduce_blanks
unsetopt hist_no_store

#
# Not have to enter cd when moving a directory,
# just enter a string that can be interpreted as a directory to cd it.
#
setopt AUTO_CD

#
# Configure to prevent being recognized as a file name.
# If the command contains meta characters (*,[],? ...) in the command,
# zsh will recognize it as a file name and return an error "no matches found.
#
setopt nonomatch

# When enter "cd -<tab_key>", it shows previously moved directories.
setopt auto_pushd

# Don't record duplicate directories with "auto_pushd".
setopt pushd_ignore_dups

# Complete by cursor position even in the middle of a word
setopt complete_in_word

#
# The parent directory, home directory, and ~/src
# can be moved from anywhere with just a directory name.
#
cdpath=(.. ~ ~/src)

# Configure completion to match uppercase even if lowercase is
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Configure to recognite immidiately of newly installed commands
zstyle ":completion:*:commands" rehash 1

# Configure to use color in completion
autoload colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# Configure to colorized display for kill candidates as well
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

# Configure to complete even if sudo is added to the command
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Configure to suppress inserting TAB with TAB when nothing is typed
zstyle ':completion:*' insert-tab false

# Function to display 'misscommand!' when typing the wrong command
command_not_found_handler()
{
	echo -e	"\e[31m            __                                                          __ __ \n" \
			".--------.|__|.-----.-----.----.-----.--------.--------.---.-.-----.--|  |  |\n" \
			"|        ||  ||__ --|__ --|  __|  _  |        |        |  _  |     |  _  |__|\n" \
			"|__|__|__||__||_____|_____|____|_____|__|__|__|__|__|__|___._|__|__|_____|__|\e[m\n"
}

# Display 'ls' and 'git status' when you press return key
zle -N _custom_return_key
bindkey '^m' _custom_return_key

## I don't really use it...
# Move to a directory one level above when you press control(^) key
#zle -N _cdup
#bindkey '^j' _cdup

# Automatic ls when moving directories
autoload -Uz add-zsh-hook
add-zsh-hook precmd _auto_ls

# Hook Function which is display just before the prompt
precmd() { _add_line }


# -------------------------------------------------------------------------------------------- #
# PATH
# -------------------------------------------------------------------------------------------- #

# Path of sbin of brew
export PATH="/usr/local/sbin:$PATH"

# Path of Latest Python
export PATH="/usr/local/opt/python@3.10/bin:$PATH"
export PATH="/usr/local/opt/python@3.10/libexec/bin:$PATH"

# Path to the binary directory of the pip (of python@3.10) package
export PATH="/usr/local/opt/python@3.10/Frameworks/Python.framework/Versions/3.10/bin:$PATH"

# Path of openjdk
export PATH="/usr/local/opt/openjdk/bin:$PATH"

#
# Path of llvm
#
# [ Notice ]
# When you use pipenv to install python, delete Homebrew's LLVM from your PATH.
# This is CPython only supports being compiled with Apple's toolchain,
# and the llvm Homebrew package conflicts.
# Also, always restart the terminal when you delete a path.
#
#export PATH="/usr/local/opt/llvm/bin:$PATH"

# Parh of Nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# Path of Larvel
export PATH="$PATH:$HOME/.composer/vendor/bin"

#
# Path to phpenv
#
# PHP multi-version installation and management for humans.
#
# GitHub ( https://github.com/phpenv/phpenv )
#
export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"

#
# Path to rbenv
#
# Seamlessly manage your app’s Ruby environment with rbenv.
#
# GitHub ( https://github.com/rbenv/rbenv )
#
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


# -------------------------------------------------------------------------------------------- #
# Alias
# -------------------------------------------------------------------------------------------- #

#
# Alias about ls like Ubuntu
#
# ls -> Alias of ls which is differentiated between directory and file colors
# ll -> Alias of ls to list files, not includeing hidden files
# la -> Alias of ls to list files, including hidden files
#
alias ls="clear && ls -G"
alias ll="clear && ls -lG"
alias la="clear && ls -alG"

# Alias of clear
alias cl="clear"

# Alias to close terminal window
alias et="exit"

# Alias to beep bell of Glass.aiff
alias se="afplay /System/Library/Sounds/Glass.aiff"

# Alias to reboot login shell
alias reb="clear && exec $SHELL -l"

#
# Alias of brew
#
# To prevent the brew command from looking at extra paths.
#
alias brew='PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin brew'

#
# Alias to add a directory to the currently open window of VScode
# Usage: advs <dir>
#
alias advs="code -a"

#
# Alias to add a file to the currently open window of VScode
# Usage: avs <file>
#
alias avs="code"

# Alias to open new simulator
alias si="figlet -f slant Open Simulator! && sudo purge && open -a Simulator"

# Alias to open new QuickTime Player
alias qp="sudo purge && open -a 'QuickTime Player'"

#
# Alias about amazon prime
#
# amav -> Alias to open Amazon Prime Video
# amam -> Alias to open Amazon Prime Music
#
alias amav="figlet -cf slant Amazon Prime Video | lolcat && open -a 'Prime Video' -n"
alias amam="figlet -cf slant Amazon Prime Music | lolcat && open -a 'Amazon Music' -n"

# Alias to display 256 colors
alias col256="clear && seq 0 255 | xargs -I {} printf '\033[38;5;{}m{}\033[m ' \
	&& cat $HOME/dotfiles/.zsh/manual_col256.txt \
	&& echo '\033[38;5;155mHello, World!\033[m\n'"

# Alias to open parallels Desktop
alias pd="sudo purge && open -a 'Parallels Desktop'"

# Alias of htop
alias am="htop"

# Alias that displays detailed information about Wi-Fi signals in the vicinity
alias diws="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s"

##
## use the file 'private_functions.sh' in .zsh directory
##

# Alias to replace the existing cd command
alias cd=_custom_cd

# Alias to open new terminal
alias tl=_new_instance_terminal

# Alias to open new Finder
alias op=_custom_open

# Alias to quit app by apple script
alias qa=_quit_app_by_apple_script

#
# Alias to free memory
# Changed permissions so that sudo purge can be used without a password.
# It can use the "sudo visudo" command to configure the settings
# (e.g. permission etc..)for the sudo commands.
#
alias fm=_purge_cache

# Alias to set MacBook not to sleep when closed
alias sleepoff="_manipulate_sleep off"

# Alias to set MacBook to sleep when closed
alias sleepon="_manipulate_sleep on"

# Alias to open the directory or file with VScode
alias vs=_open_each_directory_or_file_with_vscode

# Alias to open docker
alias dc=_manipulate_enter_docker

# Alias to display the typical system information for this computer
alias sysinfo=_show_this_computer_information

# Alias to sleep display
alias sd=_do_sleep_display

# Ailas of speedtest-cli
alias stc=_customize_speedtest-cli

# Alias to let you notify it's done
alias nd=_notify_done

# Alias to download movie of youtube, nicovideo, Vimeo, Twitter, Instagram etc..
alias dlva=_customize_yt-dlp

# Alias to set default name( Main or Sub ) of terminal
alias deti=_set_default_title_of_terminal

# Alias to start screen saver
alias ss=_start_screen_saver

# Alias to open viewer of quicklook in the background
alias ql=_execute_quicklook

# Alias to pull request with github cli
alias ghpc=_create_pull_request_on_git

# Alias to compile ts file and execute js file with node
alias tj=_compile_ts_and_execute_js

##
## use the file 'search_google.sh' in .zsh directory
##

# Alias to Search on Google engine
alias ge=_search_on_google_engine

##
## use the file 'ask_opt_snowmachine.sh' in .zsh directory
##

# Alias to snow the terminal
alias sm=_ask_opt_snowmachine

##
## use the file 'set_time.sh' in .zsh directory
##

# Aliases to set time about 'wake-up time', 'bed time', 'start time for studying', 'finish time for studying'
alias oha=_set_wake-up_time
alias oya=_set_bed_time
alias stst=_set_start_time_for_studying
alias fist=_set_finish_time_for_studying

##
## use the file 'configure_update_mas_n_brew.sh' in .zsh directory
##

# Alias to update brew and mas
alias brewup=_processes_for_updating_brew
alias masup=_processes_for_updating_mas
alias mbup=_processes_for_updating_brew_and_mas


# -------------------------------------------------------------------------------------------- #
# Environment Variables
# -------------------------------------------------------------------------------------------- #

# Japanese localization
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# An environment variable that suppresses a security feature called Gatekeeper
export HOMEBREW_CASK_OPTS=--no-quarantine

#
# GOPATH variable
#
# Used for package ansize (https://github.com/jhchen/ansize) variables.
#
export GOPATH="/usr/local/lib/go"

#
# openssl@1.1 variable
#
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig:$PKG_CONFIG_PATH"


# -------------------------------------------------------------------------------------------- #
# Display on the terminal when the .zshrc is finished loading
# -------------------------------------------------------------------------------------------- #

#
# Using Bash to display a progress indicator [duplicate]
# (https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-indicator)
#
display_progress()
{
	count=0
	total=50
	pstr="[======================================================================>]"

	while [ $count -lt $total ]; do
		sleep 0.01
		count=$(( $count + 1 ))
		pd=$(( $count * 73 / $total ))
		printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
	done
}

notify_finished_loading()
{
	terminal="$(tty | tr -d '/dev/')"

	display_progress
	echo
	if [ "$terminal" = "ttys000" ] ; then
		echo "\033[32mCompleted!!\033[m"
		echo
	else
		echo "Completed!!"
		echo -e "\e[32m              ________         __                              __         \n" \
				"            |  |  |  |.-----.|  |.----.-----.--------.-----. |  |_.-----.\n" \
				"            |  |  |  ||  -__||  ||  __|  _  |        |  -__| |   _|  _  |\n" \
				"            |________||_____||__||____|_____|__|__|__|_____| |____|_____|\n" \
				"                                                                                        \n" \
				" _______                       __               __   ________              __     __ __ \n" \
				"|_     _|.-----.----.--------.|__|.-----.---.-.|  | |  |  |  |.-----.----.|  |.--|  |  |\n" \
				"  |   |  |  -__|   _|        ||  ||     |  _  ||  | |  |  |  ||  _  |   _||  ||  _  |__|\n" \
				"  |___|  |_____|__| |__|__|__||__||__|__|___._||__| |________||_____|__|  |__||_____|__|\n"
	fi
}
notify_finished_loading
