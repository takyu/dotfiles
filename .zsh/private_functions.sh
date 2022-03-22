#!/bin/bash

ESC="$(printf '\033')"

# Function to break line after echo
_break_line_after_echo()
{
	echo "$@"
	echo
}

# Function to break line before echo
_break_line_before_echo()
{
	echo
	echo "$@"
}

# Function to add line after command
_add_line()
{
	if [ -z "$PS1_NEWLINE_LOGIN" ]; then
		PS1_NEWLINE_LOGIN=true
	else
		printf '\n'
	fi
}

# Function to notify when process is done
_notify_done()
{
	osascript -e 'display notification "Process is done!" with title "Terminal"'
	afplay /System/Library/Sounds/Glass.aiff
}

# Function to force disk cache to be purged
_purge_cache()
{
	_break_line_before_echo "--------  ${ESC}[34mPurge Cache${ESC}[m  --------"
	revolver --style 'arrow2' start
	sudo purge
	top -l 1 | grep Mem
	revolver stop
}

# Function to ask yes or no
_ask_yn()
{
	while true;
	do
		echo -n "$1 [${ESC}[34my${ESC}[m/${ESC}[31mn${ESC}[m]: "
		read -r ANS

		##
		#case "$ANS" in
		#	[Yy]*) return 0 ;;
		#	[Nn]*) return 1 ;;
		#	*) echo "${ESC}[31mError:${ESC}[m Please enter 'y' or 'n'."
		#		echo ;;
		#esac
		#

		# In Shell, true is '0' and false is others.
		if [ "$ANS" = 'Y' ] || [ "$ANS" = 'y' ] ; then
			return 0
		elif [ "$ANS" = 'N' ] || [ "$ANS" = 'n' ] ; then
			return 1
		else
			echo "${ESC}[31mError:${ESC}[m Please enter 'y' or 'n'."
			echo
		fi

	done
}

# Function to open the application by apple script
_open_app_by_apple_script()
{
	if [ $# -eq 1 ] ; then
		app=$1
		osascript -e "tell application \"$app\" to activate"
	else
		echo "${ESC}[31mError:${ESC}[m Specify only one application to be opened."
	fi
}

# Function to quit the application by apple script
_quit_app_by_apple_script()
{
	if [ $# -eq 1 ] ; then
		app=$1
		osascript -e "tell application \"$app\" to quit"
	else
		echo "${ESC}[31mError:${ESC}[m Specify only one application to be quit."
	fi
}

_new_instance_terminal()
{
	local terminal

	terminal="$(tty | tr -d '/dev/')"

	osascript -e 'tell application "Terminal" to do script activate' 1>/dev/null
	if [ "$terminal" = 'ttys000' ] ; then
		clear && echo && pfetch
		echo ">>>  ${ESC}[34mDetail of memory information${ESC}[m"
		revolver --style 'dots' start
		top -l 1 | grep Mem
		revolver stop
	fi
}

_check_git_status()
{
	if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then

		if [ -z "$(git status -s)" ] ; then
			return 0
		else
			echo -e "\n# ----------  ${ESC}[35mgit status${ESC}[m  ---------- #"
			git status -s
		fi

	fi
}

_auto_ls()
{
	if [ "${AUTOLS_DIR:-$PWD}" != "$PWD" ] ; then
		clear && ls -G

		if _check_git_status ; then
			echo
		fi
		
	fi
	AUTOLS_DIR="${PWD}"
}

_custom_cd()
{
	if [ $# -eq 0 ] ; then
		\cd || exit
		clear
	else
		\cd "$@" || return 0
	fi
}

_custom_return_key() {

	if [ -n "$BUFFER" ] ; then
		zle accept-line
		return 0
	fi

	if [ "$WIDGET" != "$LASTWIDGET" ] ; then
		CUSTOM_RETURN_COUNT=0
	fi

	clear
	case "$CUSTOM_RETURN_COUNT" in
		0)
			ls -G && _check_git_status
			((++CUSTOM_RETURN_COUNT)) ;;
		1)
			ls -aG && _check_git_status
			unset CUSTOM_RETURN_COUNT ;;
		*)
			echo "Usage: Press enter once per second to display files and directories,"
			echo "twice to display hidden files and directories as well."
			unset CUSTOM_RETURN_COUNT ;;
	esac
	
	echo -e "\n"

	zle reset-prompt
}

_cdup() {
	echo
	cd ..
	_auto_ls
	echo
	zle reset-prompt
}

_custom_open()
{
	if [ $# -eq 0 ] ; then
		open .
	else
		open "$@"
	fi
}

_open_each_directory_or_file_with_vscode()
{
	if [ $# -eq 1 ] && [ "$1" = "-h" ]; then
		_break_line_after_echo "${ESC}[32mUsage: vs (<dir>|<file> <dir>|<file> ..)${ESC}[m"
		echo "Open or create the directory or file with VScode."
		echo "Specify file or directory that you want to open or create in VSCode."
		echo "If not specified, open the current directory with VScode."
		return 0
	fi
	cowsay -f dragon-and-cow "Hello, ${USER}!" && figlet -cf slant Just coding!
	if [ $# -eq 0 ] ; then
		code -n .
	else
		code -n "$@"
	fi
}

_exit_all_terminal_opened_vscode()
{
	ps | awk 'NR>=2' | grep '/bin/zsh -l' | grep -v 'grep' | awk '{print $1}' | xargs -I@ zsh -c 'kill -9 @'
}

_manipulate_sleep()
{
	if [ $# -eq 1 ] ; then
		if [ "$1" = "on" ] ; then
			sudo pmset -a disablesleep 0
		elif [ "$1" = "off" ] ; then
			sudo pmset -a disablesleep 1
		else
			echo "${ESC}[31mError:${ESC}[m Specify only one word, 'on' or 'off'."
		fi
	else
		echo "${ESC}[31mError:${ESC}[m Specify vaild one argument."
	fi
}

_start_screen_saver()
{
	if [ $# -eq 0 ] ; then
		_manipulate_sleep on
		_open_app_by_apple_script "Jiggler"
		/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine
		_quit_app_by_apple_script "Jiggler"
		_manipulate_sleep off
	elif [ $# -eq 1 ] && [ "$1" = '--not-always-display-login-screen' ]; then
		/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine
	else
		_break_line_after_echo "${ESC}[31mError:${ESC}[m Invalid option is specified."
		echo "Usage:ss [option]"
		echo "[option]"
		_break_line_after_echo "'--not-always-display-login-screen' -> Don't always display the login screen"
	fi
}

_show_all_information()
{
	echo -e "${ESC}[34mKeywords related to Datatype are listed below.${ESC}[m"
	_break_line_after_echo "Usage: system_profiler {Datatype} ({Datatype}..)"
	system_profiler -listDataTypes
	echo
	vm_stat | \
		perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576);'
	echo
	neofetch
	neofetch --clean
}

_show_battery_information()
{
	echo ">>>  ${ESC}[34mDetail of battery information${ESC}[m"
	ioreg -l | grep \ \"MaxCapacity | sed -e 's/[ \|]//g' | sed -e 's/\"//g'
	ioreg -l | grep \ \"CurrentCapacity | sed -e 's/[ \|]//g' | sed -e 's/\"//g'
	ioreg -l | grep \ \"DesignCapacity | sed -e 's/[ \|]//g' | sed -e 's/\"//g'
}

_do_sleep()
{
	terminal="$(tty | tr -d '/dev/')"

	clear
	if [ "$terminal" = "ttys000" ] ; then

		pokemonsay -n -p Chansey "Get plenty of rest and relax."
		_quit_app_by_apple_script "Brave Browser" && _exit_all_terminal_opened_vscode
		_show_battery_information
		_purge_cache && echo
		revolver --style 'arrow2' start " ${ESC}[32mSoon this computer will go into sleep mode..${ESC}[m"
		sleep 10;revolver stop && _manipulate_sleep on && pmset sleepnow

	else

		pokemonsay -n -p Charmander "Come right back!"
		sleep 2;pmset displaysleepnow

	fi
}

_customize_speedtest-cli()
{
	_break_line_before_echo "## Display current wireless status, e.g. signal info, BSSID, port type etc."
	/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I
	_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"
	echo "## Memory is being free so that the speed can be measured optimally.."
	_purge_cache
	_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"
	date="$(date +'%Y %B %e %A %H:%M:%S')"
	echo "## Start speed test. ( $date )"
	speedtest-cli --secure --share | tee >(rotatelogs -n 3 /tmp/speed_result.log 1M)
	_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"
	echo "## Display the measurement results of the speed test.."
	url="$(cat /tmp/speed_result.log | grep "Share results" | awk '{print $3}')"
	open -a 'Google Chrome' -n --args --incognito --new-window "$url"
	sleep 2;_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"
	echo "## Save the date of executing the speed test and the URL of the result in 'speedtest_history.log'.."
	echo "$date -> $url" >> "$HOME"/Documents/times/speedtest_history.log
	_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"
	rm -f /tmp/speed_result.log
	_notify_done
}

_customize_yt-dlp()
{
	clear
	if [ $# -eq 0 ] ; then
		echo
		_break_line_after_echo "'dlva' is an alias for 'yt-dlp' with the --verbose, --print-traffic, --progress, and --console-title options."
		echo "'yt-dlp' is a youtube-dl fork based on the now inactive youtube-dlc."
		_break_line_after_echo "'youtube-dl' is a download videos from youtube.com or other video platforms."
		echo "GitHub is as follows."
		echo "yt-dlp ( https://github.com/yt-dlp/yt-dlp )"
		_break_line_after_echo "youtube-dl ( https://github.com/ytdl-org/youtube-dl )"
		_break_line_after_echo "${ESC}[32mUsage: dlva [OPTIONS] URL [URL...]${ESC}[m"
		_break_line_after_echo "For detailed usage and to see other options, enter '-h' or '--help'."
		echo "For example, use the following."
		echo "When looking up downloadable formats,"
		_break_line_after_echo "${ESC}[33mdlva -F {URL_Movie}${ESC}[m"
		echo "When downloading in a specific format,"
		echo "${ESC}[33mdlva -f {ID_video}+{ID_audio} --merge-output-format {FORMAT(e.g. mp4)} {URL} -o {output_filename}${ESC}[m"
	elif [ "$1" = '-h' ] || [ "$1" = '--help' ] ; then
		yt-dlp "$1"
	elif [ "$1" = '-F' ] ; then
		yt-dlp --verbose --print-traffic "$@"
	else
		sudo purge
		yt-dlp --verbose --print-traffic --progress --console-title "$@"
		_notify_done
	fi
}

_set_default_title_of_terminal()
{
	terminal="$(tty | tr -d '/dev/')"

	if [ "$terminal" = "ttys000" ] ; then
		echo -e "${ESC}];Main\007"
	else
		echo -e "${ESC}];Sub\007"
	fi

	clear
}

_execute_quicklook()
{
	qlmanage -p > /dev/null 2>&1 "$@" &
}

_create_pull_request_on_git()
{
	local head title body

	if [ $# -eq 0 ] ; then
		_break_line_after_echo "${ESC}[31mError:${ESC}[m Specify branch which you want to merge."
		_break_line_after_echo "Usage: ghpc [branch] [title] [body]"
		echo "[branch]: Specify branch which you want to merge."
		echo "[title]: Optional. Specify a pull request title."
		echo "[body]: Optional. Specify a pull request comment."
		return 0
	fi

	head="$(git rev-parse --abbrev-ref HEAD)"
	title=""
	body=""

	if [ -n "$2" ] ; then
		title=$2
	fi

	if [ -n "$3" ]; then
		body=$3
	fi

	gh pr create --base "$1" --head "$head" --title "$title" --body "$body"
}

_manipulate_enter_docker()
{
	local is_open

	is_open="$(\docker images 2>/dev/null)"

	if [ -n "$is_open" ] ; then

		if [ $# -gt 0 ] && [ "$1" = "c" ] ; then
			shift
			\docker compose "$@"
			return 0
		fi

		\docker "$@"

		if [ $# -eq 0 ] || { [ $# -eq 1 ] && [ "$1" = "-y" ]; }; then

			echo
			if [ $# -eq 1 ] ; then
				if yes | _ask_yn "Quit the Docker app?" ; then
					_quit_app_by_apple_script Docker &
				fi
			else
				if _ask_yn "Quit the Docker app?" ; then
					_quit_app_by_apple_script Docker &
				fi
			fi

		fi

	else
		clear
		echo -e "  ___________ \n" \
			"< Hi, $USER!!>\n" \
			" ----------- \n" \
			"    \ \n" \
			"     \ \n" \
			"      \     \n" \
			"                    ##        .            \n" \
			"              ## ## ##       ==            \n" \
			"           ## ## ## ##      ===            \n" \
			"       /\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"___/ ===        \n" \
			"  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~   \n" \
			"       \______ o          __/            \n" \
			"        \    \        __/             \n" \
			"          \____\______/   \n" \
			"                                            \n"

		figlet -f slant Open Docker.
		open -a Docker

		if [ $# -gt 0 ] ; then
			_break_line_before_echo "${ESC}[36mInfo:${ESC}[m When docker starts, enter it again!"
			_break_line_before_echo "command: dc $*"
		fi
	fi
}

_compile_ts_and_execute_js()
{
	local ts js

	if [ ! $# -eq 1 ] ; then
		echo "${ESC}[31mError:${ESC}[ Specified only one ts file."
		return 0
	elif [[ ! "$1" =~ ^.*.ts$ ]] ; then
		echo "${ESC}[31mError:${ESC}[ Specified ts file."
		return 0
	fi

	ts="$1"

	##
	#
	# SC2001 (https://github.com/koalaman/shellcheck/wiki/SC2001)
	#
	# See if you can use ${variable//search/replace} instead.
	#
	##

	#js="$(echo "$ts" | sed 's/.ts/.js/g')"
	js=$(echo "${ts//.ts/.js}")

	tsc "$ts" && node "$js"
}
