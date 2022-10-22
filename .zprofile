load-nvm () 
{
	export NVM_DIR="$HOME/.nvm"

	# This loads nvm
	[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"

	# This loads nvm bash_completion
	[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
}

load-nvmrc() 
{
	local node_version nvmrc_path nvmrc_node_version

	if [[ -f .nvmrc && -r .nvmrc ]]; then

		if ! type nvm >/dev/null; then
			load-nvm
		fi

		node_version="$(nvm version)"
		nvmrc_path="$(nvm_find_nvmrc)"

		if [ -n "$nvmrc_path" ]; then
			nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

		if [ "$nvmrc_node_version" = "N/A" ]; then
			nvm install
		elif [ "$nvmrc_node_version" != "$node_version" ]; then
			nvm use
		fi
		elif [ "$node_version" != "$(nvm version default)" ]; then
			echo "Reverting to nvm default version"
			nvm use default
		fi
	fi
}

# Load nvm package when .nvmrc is here
if [[ -f .nvmrc && -r .nvmrc ]]; then
	echo  "\033[35m>>> load nvm packages and apply..\033[m"
	load-nvmrc && clear
fi

