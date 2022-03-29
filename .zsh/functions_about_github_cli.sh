#!/bin/bash

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

_confirm_file_of_pull_requested_branch()
{
	local number

	gh pr list;
    echo "Enter the number of PR to checkout: " && read -r number;
    gh pr checkout "$number";
}

_display_diff_of_pull_request_list()
{
	local number

	gh pr list;
    echo "Enter the number of PR to checkout: " && read -r number;
    gh pr diff "$number";
}


_create_repository_and_change_default_branch()
{
	local repo_name repo_description default_branch

	git init && git add . && git commit -m "First commit"

	echo "Enter repository name: " && read -r repo_name;
    echo "Enter repository description: " && read -r repo_description;
	echo "Enter the default branch name: " && read -r default_branch;

	gh repo create "$repo_name" --description "$repo_description"
	git remote add origin https://github.com/deatiger/"$repo_name".git

	if [ -n "$default_branch" ] ; then
		git checkout -b "$default_branch"
	else
		default_branch="main"
	fi
	
	git push -u origin "$default_branch"
}
