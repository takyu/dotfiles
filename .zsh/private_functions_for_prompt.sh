#!/bin/bash

_display_battery_amount()
{
	local ba_amount ba_status

	ba_amount="$(pmset -g ps | awk 'NR==2' | awk '{print $3}' | sed 's/%;//g')"
	ba_status="$(pmset -g ps | awk 'NR==1' | awk '{print $4, $5}')"

	if [ "$ba_status" = "'AC Power'" ] ; then
		echo -n "%F{cyan}${ba_amount}%f%%"
		return 0
	fi
	
	if [ "$ba_amount" -gt 50 ] ; then
		echo "%F{green}${ba_amount}%f%%"
	elif [ "$ba_amount" -gt 20 ] ; then
		echo "%F{yellow}${ba_amount}%f%%"
	else
		echo "%F{red}${ba_amount}%f%%"
	fi

}

_display_git_current_branch()
{
	local branch_name st branch_status

	st="$(git status 2> /dev/null)"

	if [ -z "$st" ] ; then
		return 0
	fi

	branch_name="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

	if [ -n "$(git log origin/"${branch_name}".."${branch_name}" 2> /dev/null)" ] ; then

		# No push yet!!
		branch_status="%F{red}!!"

	elif [ -n "$(echo "$st" | grep "^nothing to")" ] ; then

		# Have never pushed!!
		if [ -n "$(git log origin/"${branch_name}".."${branch_name}" 2>&1 > /dev/null)" ] ; then
			branch_status="%F{red}!!(never)"
		else
			# All commit
			branch_status="%F{cyan}"
		fi

	elif [ -n "$(echo "$st" | grep "^Untracked files")" ] &&
		[ -n "$(echo "$st" | grep "^Changes not staged for commit")" ] ; then

		# No manage and add files yet
		branch_status="%F{yellow}??M"

	elif [ -n "$(echo "$st" | grep "^Untracked files")" ] ; then

		# No manage files
		branch_status="%F{yellow}??"

	elif [ -n "$(echo "$st" | grep "^Changes not staged for commit")" ] ; then

		# No add yet
		branch_status="%F{yellow}M"

	elif [ -n "$(echo "$st" | grep "^Changes to be committed")" ] ; then

		# No commit yet!
		branch_status="%F{red}!"

	elif [ -n "$(echo "$st" | grep "^rebase in progress")" ] ; then

		# Conflict!
		echo "%F{red}!< no branch >!%f"
		return 0

	else

		# Woops..?
		branch_status="%F{purple}"

	fi

	echo "${branch_status}[${branch_name}]%f"
}