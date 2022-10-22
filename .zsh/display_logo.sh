#!/bin/bash

_display_github_cli_logo()
{
	figlet -f slant github cli && gh --version | awk 'NR==1'
}

_display_sppedtest_cli_logo()
{
	figlet -f slant speedtest-cli && speedtest-cli --version
}

_display_docker_logo()
{
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

	figlet -f slant Open Docker. && docker -v
}

_display_yt-dlp_logo()
{
	figlet -f slant yt-dlp && echo -n "yt-dlp " && yt-dlp --version
}

_display_mas-cli_logo()
{
	figlet -f slant mas-cli && echo -n "mas-cli " && mas version
}

_display_homebrew_logo()
{
	figlet -f slant Homebrew && brew -v
}
