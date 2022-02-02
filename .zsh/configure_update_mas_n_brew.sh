#!/bin/bash

choose_init_display()
{
	if _ask_yn "enter 'y' to initialize the display, or 'n' to exit not to initialize it." ; then
		_custom_cd
	else
		echo
	fi
}

brew_check_res()
{
	res="$(brew doctor)"
	echo "${ESC}[31;42mdone.${ESC}[m"

	if [ "$res" = "Your system is ready to brew." ]; then
		echo -e "${ESC}[32m                _______          __                                \n" \
				"              |    |  |.-----. |__|.-----.-----.--.--.-----.-----.\n" \
				"              |       ||  _  | |  ||__ --|__ --|  |  |  -__|__ --|\n" \
				"              |__|____||_____| |__||_____|_____|_____|_____|_____|\n" \
				"                                                                  \n" \
				"                      _______                       __ __ \n" \
				"                     |    ___|.-----.--.--.-----.--|  |  |\n" \
				"                     |    ___||  _  |  |  |     |  _  |__|\n" \
				"                     |___|    |_____|_____|__|__|_____|__|${ESC}[m\n"
		return 0
	else
		echo -e	"${ESC}[31m            _______                        __   __     __              \n" \
				"          |     __|.-----.--------.-----.|  |_|  |--.|__|.-----.-----.\n" \
				"          |__     ||  _  |        |  -__||   _|     ||  ||     |  _  |\n" \
				"          |_______||_____|__|__|__|_____||____|__|__||__||__|__|___  |\n" \
				"                                                               |_____|\n" \
				"                    ________                          __ __ \n" \
				"                   |  |  |  |.----.-----.-----.-----.|  |  |\n" \
				"                   |  |  |  ||   _|  _  |     |  _  ||__|__|\n" \
				"                   |________||__| |_____|__|__|___  ||__|__|\n" \
				"                                              |_____|       ${ESC}[m\n"
		echo "${ESC}[31m[[ Warning ]]${ESC}[m"
		echo "Immediately, resolve the above errors and warnings!!"
		return 1
	fi
}

do_brew_update()
{
	echo
	echo "# ------------------------------------------------------------------------------------------------- #"
	echo "# ${ESC}[32m brew version                                                                                     ${ESC}[37m#"
	echo "# ------------------------------------------------------------------------------------------------- #"
	brew -v
	echo

	echo "# ------------------------------------------------------------------------------------------------- #"
	echo "# ${ESC}[32m brew update start                                                                                ${ESC}[37m#"
	echo "# ------------------------------------------------------------------------------------------------- #"
	brew update
	_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"

	while true;
	do
		OPT=""
		echo -n "Will it upgrade with the greedy option? (after 4 seconds, it will run without option) [${ESC}[34my${ESC}[m/${ESC}[31mn${ESC}[m]: "
		read -t 4 -r OPT
		if [ -z "$OPT" ] ; then
			echo
		fi
		if [ "$OPT" = 'Y' ] || [ "$OPT" = 'y' ] ; then
			echo
			echo "# ------------------------------------------------------------------------------------------------- #"
			echo "# ${ESC}[32m brew outdated start with --greedy option                                                         ${ESC}[37m#"
			echo "# ------------------------------------------------------------------------------------------------- #"
			brew outdated --greedy
			_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"

			echo "# ------------------------------------------------------------------------------------------------- #"
			echo "# ${ESC}[32m brew upgrade start with --greedy option                                                          ${ESC}[37m#"
			echo "# ------------------------------------------------------------------------------------------------- #"
			brew upgrade --greedy
			_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"

			break
		elif  [ -z "$OPT" ] || [ "$OPT" = 'N' ] || [ "$OPT" = 'n' ] ; then
			echo
			echo "# ------------------------------------------------------------------------------------------------- #"
			echo "# ${ESC}[32m brew outdated start                                                                              ${ESC}[37m#"
			echo "# ------------------------------------------------------------------------------------------------- #"
			brew outdated
			_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"

			echo "# ------------------------------------------------------------------------------------------------- #"
			echo "# ${ESC}[32m brew upgrade start                                                                               ${ESC}[37m#"
			echo "# ------------------------------------------------------------------------------------------------- #"
			brew upgrade
			_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"
			
			break
		else
			_break_line_after_echo "${ESC}[31mError:${ESC}[m Please enter 'y' or 'n' or please hold for four seconds."
		fi
	done

	echo "# ------------------------------------------------------------------------------------------------- #"
	echo "# ${ESC}[32m brew cleanup start                                                                               ${ESC}[37m#"
	echo "# ------------------------------------------------------------------------------------------------- #"
	brew cleanup
	_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"

	echo "# ------------------------------------------------------------------------------------------------- #"
	echo "# ${ESC}[32m brew doctor start                                                                                ${ESC}[37m#"
	echo "# ------------------------------------------------------------------------------------------------- #"
}

do_mas_update()
{
	echo
	echo "# ------------------------------------------------------------------------------------------------- #"
	echo "# ${ESC}[32m mas version                                                                                      ${ESC}[37m#"
	echo "# ------------------------------------------------------------------------------------------------- #"
	version="$(mas version)"
	_break_line_after_echo "mas $version"

	echo "# ------------------------------------------------------------------------------------------------- #"
	echo "# ${ESC}[32m mas outdated start                                                                               ${ESC}[37m#"
	echo "# ------------------------------------------------------------------------------------------------- #"
	mas outdated
	_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"

	echo "# ------------------------------------------------------------------------------------------------- #"
	echo "# ${ESC}[32m mas upgrade start                                                                                ${ESC}[37m#"
	echo "# ------------------------------------------------------------------------------------------------- #"
	mas upgrade
	_break_line_after_echo "${ESC}[31;42mdone.${ESC}[m"

	echo "${ESC}[32mmas update was done!!${ESC}[m"
}

# brewup
_processes_for_updating_brew()
{
	do_brew_update
	if brew_check_res ; then
		_notify_done
		choose_init_display
	else
		_notify_done
	fi
}

# masup
_processes_for_updating_mas()
{
	do_mas_update
	_notify_done
	choose_init_display
}

# mbup
_processes_for_updating_brew_and_mas()
{
	do_mas_update
	_processes_for_updating_brew
}