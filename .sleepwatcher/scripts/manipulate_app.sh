#!/bin/sh

open_app()
{
	if [ "$1" = 'Terminal' ] ; then
		open -a "$1"
	else
		osascript -e "tell application \"$1\" to activate"
	fi
}

quit_app()
{
	osascript -e "tell application \"$1\" to quit"
}