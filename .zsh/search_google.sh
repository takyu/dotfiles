#!/bin/bash

set_option()
{
	if [[ "$1" =~ "-" ]] && [ ${#1} -gt 1 ] ; then
		if [ ${#1} -gt 4 ] ; then
			echo "Error 1"
		elif [[ "$1" =~ "c" ]] && [[ "$1" =~ "b" ]] ; then
			echo "Error 2"
		elif [[ ! "$1" =~ ^-[cbiyhm]+$ ]] ; then
			echo "Error 3"
		elif [[ "$1" =~ "h" ]] && [[ ${#1} -gt 2 ]] ; then
			echo "Error 4"
		elif [ "$(echo "$1" | awk '{count += (split($0, arry, "c") - 1)} END{print count}')" -gt 1 ] ||
				[ "$(echo "$1" | awk '{count += (split($0, arry, "b") - 1)} END{print count}')" -gt 1 ] ; then
			echo "Error 5"
		elif [ "$(echo "$1" | awk '{count += (split($0, arry, "i") - 1)} END{print count}')" -gt 1 ] ||
				[ "$(echo "$1" | awk '{count += (split($0, arry, "y") - 1)} END{print count}')" -gt 1 ] ||
				[ "$(echo "$1" | awk '{count += (split($0, arry, "m") - 1)} END{print count}')" -gt 1 ] ; then
			echo "Error 6"
		elif [[ "$1" =~ "y" ]] && [[ "$1" =~ "m" ]] ; then
			echo "Error 7"
		else
			if [[ ! "$1" =~ "c" ]] && [[ ! "$1" =~ "b" ]] && [[ ! "$1" =~ "h" ]]; then
				echo "${1}b"
			else
				echo "$1"
			fi
		fi
	else
		echo "Error 8"
	fi
}

set_url()
{
	local en_google google_top en_youtube youtube_top google_maps en_google_maps

	en_google="https://www.google.com/search?q="
	google_top="https://www.google.com/"

	en_youtube="https://www.youtube.com/results?search_query="
	youtube_top="https://www.youtube.com/"

	google_maps="https://www.google.com/maps"
	en_google_maps="https://www.google.com/maps/search/"

	if [[ "$2" =~ ^https?://.*$ ]] ; then

		echo "$2"

	elif [ "$2" = "" ] ; then

		if [[ "$1" =~ "y" ]] ; then
			echo "$youtube_top"
		elif [[ "$1" =~ "m" ]] ; then
			echo "$google_maps"
		else
			echo "$google_top"
		fi

	else

		if [[ "$1" =~ "y" ]] ; then
			echo "${en_youtube}${2}"
		elif [[ "$1" =~ "m" ]] ; then
			echo "${en_google_maps}${2}"
		else
			echo "${en_google}${2}"
		fi

	fi
}

display_terminal()
{
	local normal incognito youtube maps error

	normal="clear && pokemonsay -n -p Mewtwo Open normal mode."
	incognito="clear && pokemonsay -n -p Mew Open incognito mode."
	youtube="clear && pokemonsay -n -p Pikachu Enjoy YouTube!!"
	maps="clear && pokemonsay -n -p Dragonite Where to go??"
	error="pokemonsay -n -p Psyduck Ummm... I forgot what to say."

	case "$1" in

		"normal" ) eval "$normal" ;;
		"incognito" ) eval "$incognito" ;;
		"youtube" ) eval "$youtube" ;;
		"maps" ) eval "$maps" ;;
		"error" ) eval "$error" ;;
		*) echo "${ESC}[31mError:${ESC}[m target option display is not set." ;;

	esac

}

do_exception()
{
	local err_num

	err_num="$(echo "$1" | awk '{print $2}')"

	clear
	case "$err_num" in
		"1" ) echo "${ESC}[31mError:${ESC}[m Too many arguments." ;;
		"2" ) echo "${ESC}[31mError:${ESC}[m Specified can be only one browser." ;;
		"3" ) echo "${ESC}[31mError:${ESC}[m Invalid options are included or the '-' is misplaced." ;;
		"4" ) echo "${ESC}[31mError:${ESC}[m Only write the '-h' option, when see Usage." ;;
		"5" ) echo "${ESC}[31mError:${ESC}[m Included two or more of the same Browsers." ;;
		"6" ) echo "${ESC}[31mError:${ESC}[m Included two or more of the same options." ;;
		"7" ) echo "${ESC}[31mError:${ESC}[m Specified can be only one of y or m." ;;
		"8" ) echo "${ESC}[31mError:${ESC}[m Argument '-' is not specified or only written '-'." ;;
	esac
	_break_line_after_echo "To see Usage, write only the -h option. ( 'ge -h' )"
	display_terminal "error"
}

explain_usage()
{
	_break_line_before_echo "Usage: ge -${ESC}[36m[Browsers]${ESC}[m${ESC}[32m[options]${ESC}[m ${ESC}[35m[words or URL]${ESC}[m"
	_break_line_before_echo "${ESC}[36m[Browsers]${ESC}[m: c: Chrome or b: Brave Browser (Specified only one browser.)"
	echo "${ESC}[32m[options]${ESC}[m: h: help, i: incognito mode, y: youtube, m: google maps (Specified only one of y or m)"
	echo "${ESC}[35m[words]${ESC}[m: Words to search or URL to do(If omitted, go to top page)"
	_break_line_before_echo "${ESC}[31m[[ Notice ]]${ESC}[m"
	echo "・If you write only 'ge', open 'New Tab' in Brave."
	echo "・If you write 'ge [URL]', search for the URL in Brave."
	echo "・If only some valid option is given,
		'Brave' will be set as the Browser even if no browser is specified."
}

use_chrome_browser()
{
	local url chrome sec_chrome

	url="$(set_url "$1" "$2")"
	chrome="open -a 'Google Chrome' -n --args --new-window"
	sec_chrome="open -a 'Google Chrome' -n --args --incognito --new-window"

	if [[ "$1" =~ "i" ]] ; then

		if [[ "$1" =~ "y" ]] ; then
			display_terminal "youtube" && eval "$sec_chrome" "$url"
		elif [[ "$1" =~ "m" ]] ; then
			display_terminal "maps" && eval "$sec_chrome" "$url"
		else
			display_terminal "incognito" && eval "$sec_chrome" "$url"
		fi

	elif [[ "$1" =~ "y" ]] ; then

		display_terminal "youtube" && eval "$chrome" "$url"

	elif [[ "$1" =~ "m" ]] ; then

		display_terminal "maps" && eval "$sec_chrome" "$url"

	else

		display_terminal "normal" && eval "$chrome" "$url"

	fi
}

use_brave_browser()
{
	local url brave sec_brave

	url="$(set_url "$1" "$2")"
	brave="open -a 'Brave Browser' -n --args --new-window"
	sec_brave="open -a 'Brave Browser' -n --args --incognito --new-window"

	if [[ "$1" =~ "i" ]] ; then

		if [[ "$1" =~ "y" ]] ; then
			display_terminal "youtube" && eval "$sec_brave" "$url"
		elif [[ "$1" =~ "m" ]] ; then
			display_terminal "maps" && eval "$sec_brave" "$url"
		else
			display_terminal "incognito" && eval "$sec_brave" "$url"
		fi

	elif [[ "$1" =~ "y" ]] ; then

		display_terminal "youtube" && eval "$brave" "$url"

	elif [[ "$1" =~ "m" ]] ; then

		display_terminal "maps" && eval "$brave" "$url"

	else

		display_terminal "normal" && eval "$brave" "$url"

	fi
}

_search_on_google_engine()
{
	local option word

	# early return as to open Brave Browser
	if [ $# -eq 0 ] || { [ $# -eq 1 ] && [[ "$1" =~ ^https?://.*$ ]]; } ; then
		clear && pokemonsay -n -p Eevee "Open 'New Tab' in Brave!"

		if [ $# -eq 0 ] ; then
			open -a 'Brave Browser' -n --args --new-window
		else
			open -a 'Brave Browser' -n --args --new-window "$1"
		fi

		return 0
	fi

	option="$(set_option "$1")"
	shift
	word="${*// /+}"

	if [[ "$option" =~ "Error" ]] ; then

		do_exception "$option"

	elif [ "$option" = "-h" ] ; then

		explain_usage

	elif [[ "$option" =~ "c" ]] ; then

		use_chrome_browser "$option" "$word"

	elif [[ "$option" =~ "b" ]] ; then

		use_brave_browser "$option" "$word"

	else
		echo "What the hell? Unexpected error.."
	fi
}