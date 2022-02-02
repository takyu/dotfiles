#!/bin/bash

_ask_opt_snowmachine()
{
	clear
	_break_line_after_echo "${ESC}[34mNote:${ESC}[m After 4 seconds without entering anything, It snow without piling up.."
	while true;
	do
		ANS=""
		echo -n "Do you want to make the snow pile up? [${ESC}[34my${ESC}[m/${ESC}[31mn${ESC}[m]: "
		read -t 4 -r ANS
		if [ -z "$ANS" ] ; then
			snowmachine
			break
		elif [ "$ANS" = 'Y' ] || [ "$ANS" = 'y' ] ; then
			if _ask_yn "And, do you want to make snow colorful?"; then
				snowmachine --stack=pile --color=rainbow
				break
			else
				snowmachine --stack=pile
				break
			fi
		elif [ "$ANS" = 'N' ] || [ "$ANS" = 'n' ] ; then
			if _ask_yn "Do you want to make snow colorful?" ; then
				snowmachine --color=rainbow
				break
			else
				snowmachine
				break
			fi
		else
			_break_line_after_echo "${ESC}[31mError:${ESC}[m Please enter 'y' or 'n' or please hold for four seconds."
		fi
	done
}
