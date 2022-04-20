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

	_display_github_cli_logo && echo

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

	_display_github_cli_logo && echo

	gh pr list;
    echo -n "Enter the number of PR to checkout: " && read -r number;
    gh pr checkout "$number";
}

_display_diff_of_pull_request_list()
{
	local number

	_display_github_cli_logo && echo

	gh pr list;
    echo -n "Enter the number of PR to checkout: " && read -r number;
    gh pr diff "$number";
}


_create_repository_and_change_default_branch()
{
	local user_name name description branch visibility

	user_name="$(git config user.name)"

	if [ $# -ge 1 ] && [ "$1" = "notlogo" ] ; then
		:
	else
		_display_github_cli_logo
	fi

	_break_line_both_echo "-------  ${ESC}[34mgit init${ESC}[m  -------" && git init
	_break_line_both_echo "-------  ${ESC}[32mgit add . & git status${ESC}[m  -------" && git add . && git status
	_break_line_after_echo "-------  ${ESC}[33mgit commit -m 'First commit'${ESC}[m  -------" && git commit -m "First commit"

	_break_line_both_echo "-------  ${ESC}[35msetting options of git${ESC}[m  -------"

	if _ask_yn "Is the repository name to be the same as the project(directory) name?" ; then
		name="$(basename "$(pwd)")"
		echo "Enter repository name: ${name}"
	else
		while true;
		do
			echo -n "Enter repository name: "
			read -r name;

			if [ -z "$name" ] ; then
				echo "${ESC}[31mError:${ESC}[m Specify repository name."
				echo
			else
				break
			fi
		done
	fi
	
    echo -n "Enter repository description: " && read -r description;
	echo -n "Enter the default branch name (If nothing is entered, it will be main) : " && read -r branch;

	while true;
	do
		echo -n "Enter number [1: public 2: private 3: internal] : "
		read -r visibility

		if [ "$visibility" = "1" ] ; then
			_break_line_both_echo "-------  creating ${ESC}[34mpublic${ESC}[m repository now..  -------"
			gh repo create "$name" -d "$description" --public
			break
		elif [ "$visibility" = "2" ] ; then
			_break_line_both_echo "-------  creating ${ESC}[31mprivate${ESC}[m repository now..  -------"
			gh repo create "$name" -d "$description" --private
			break
		elif [ "$visibility" = "3" ] ; then
			_break_line_both_echo "-------  creating ${ESC}[32minternal${ESC}[m repository now..  -------"
			gh repo create "$name" -d "$description" --internal
			break
		else
			echo "${ESC}[31mError:${ESC}[m Please enter '1' or '2' or '3' ."
			echo
		fi
	done

	if [ -n "$branch" ] ; then
		git branch -M "$branch"
	else
		branch="main"
		git branch -M main
	fi

	git remote add origin git@github.com:"$user_name"/"$name".git

	_break_line_both_echo "-------  ${ESC}[36mgit push${ESC}[m origin / ${ESC}[36m${branch}${ESC}[m  -------"

	git push -u origin "$branch"
}

_create_project_and_repository()
{
	local project

	_display_github_cli_logo

	_break_line_both_echo "-------  ${ESC}[35mcreate project (directory)${ESC}[m  -------"
	while true;
	do
		echo -n "Enter project(directory) name: "
		read -r project;

		if [ -z "$project" ] ; then
			echo "${ESC}[31mError:${ESC}[m Specify project(directory) name."
			echo
		else
			break
		fi
	done
	echo "project name : ${project}"

	mkdir "$project" && echo "# ${project}" > "$project"/README.md
	cd "$project" && _create_repository_and_change_default_branch "notlogo"
	cd ../ && _open_each_directory_or_file_with_vscode "$project"
}

_delete_repository()
{
	local user_name repo_name

	user_name="$(git config user.name)"

	_display_github_cli_logo && echo

	if [ $# -eq 1 ] && [ "$1" == "-s" ] ; then
		gh repo delete --confirm
	else
		echo -n "Enter repository name: " && read -r repo_name;
		expect -c "
			set timeout 2
			spawn gh repo delete
			expect \"? Type ${user_name}/${repo_name} to confirm deletion:\"
			send \"${user_name}/${repo_name}\n\"
			interact
		"
	fi
}
