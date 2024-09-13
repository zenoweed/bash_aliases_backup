# .bash commands

# fortune | lolcat

alias reb='source ~/.bashrc && echo -e "[RELOAD] .bashrc"'

alias elias='code ~/.bash_aliases && exit'
alias rcdit='code ~/.bashrc && exit'

# Linux general commands

check_connectivity() {
	test_ip="8.8.8.8"
	test_count=1

	if ping -c ${test_count} ${test_ip} > /dev/null; then
		echo "[ONLINE] Internet Available"
	else
		echo "[OFFLINE] Internet Unavailable"
	fi
}

alias kaf='kubectl apply -f'
alias c='clear'
alias h='history'
alias g='grep'
alias bx='bash -x'
alias cx='chmod +x'
alias sa='sudo apt'
alias hg='history | grep'
alias pg='ping google.com'
alias ll='lolcat'
alias sai='sudo apt install'
alias sar='sudo apt remove'
alias sau='sudo apt update'
alias sauu='sudo apt-get update && sudo apt-get upgrade'
alias netch='check_connectivity'
alias sat='sudo apt autoremove'
alias myip="echo \"Your Public IP details:\" && curl -sS ipinfo.io | yq eval -M -P | yq"
alias ports='netstat -tulanp'
alias workspace='/home/brian/Documents/os-scripts/workspace.sh'
alias sopa='sops -i -r --add-pgp'
alias sopf='sopf'
alias gpl='gpg --list-key'
alias clip='xclip -selection clipboard'
alias list='ls -hlrt'
alias rm="rm -rf"
alias dow='cd ${HOME}/Downloads/'
alias doc='cd ${HOME}/Documents/'
alias docr='fuzzfunc code ${HOME}/Documents/repos'
alias docrl='cd ${HOME}/Documents/repos'
alias docs='fuzzfunc code ${HOME}/Documents/secretfiles'
alias docsl='cd ${HOME}/Documents/secretfiles'
alias dock='fuzzfunc code ${HOME}/Documents/sshkeys'
alias dockl='cd ${HOME}/Documents/sshkeys'
alias docw='fuzzfunc code ${HOME}/Documents/workspace'
alias docwl='cd ${HOME}/Documents/workspace'
alias doco='fuzzfunc code ${HOME}/Documents/os-scripts'
alias docol='cd ${HOME}/Documents/os-scripts'
alias doce='fuzzfunc code ${HOME}/Documents/emails'
alias docel='cd ${HOME}/Documents/emails'
alias gmt='go mod tidy'
alias jcli='java -jar /home/brian/Documents/os-scripts/jenkins-cli.jar -auth $JENKINS_USER_TOKEN_8885 -s http://localhost:8885/'
alias infile='grep -nr'
alias sopd='sopd'
alias t='task'
# alias ='git config pull.rebase false'

sopf(){
	# find . -type f -name "*.ini" -exec sops -i -r --add-pgp $1 {} \;
	find . -type f -name "*.ini" | parallel --verbose sops -i -r --add-pgp $1 {}
	echo "Added $1 to:"
	find . -type f -name "*.ini"
}
sopd(){
	sops -d "$1" | jc --ini | jq 'walk(if type == "string" then @base64d else . end)'
}
secd(){
	cat $1 | yq '.data' | jc --ini | jq 'walk(if type == "string" then @base64d else . end)'
}

cld() {
	# Get the last downloaded item in the downloads directory
	local last_download=$(ls -t ~/Downloads | head -n 1)

	# Check if there's any file in the Downloads directory
	if [ -z "$last_download" ]; then
		echo "No files found in Downloads directory."
		exit 1
	fi

	# Copy the last downloaded item to the current directory
	if [ -n "$1" ]; then
		cp -r ~/Downloads/"$last_download" "$1"
	else
		cp -r ~/Downloads/"$last_download" .
	fi

	echo "Copied $last_download to $1"
}

alias cld='cld'

fuzz() {
    local dirs="$2"
	local dir=$(cat /home/brian/.repolist | fzf)
	if [ -n "$dir" ]; then
		if [ -d "$dirs/$dir" ]; then
			echo "$dirs/$dir exists offline. Now opening"
			$1 "$dirs/$dir"
		else
			echo "$dirs/$dir not found offline. Now Cloning:"
			git clone git@github.com:spintlyinc/$dir.git $dirs/$dir
			echo "Now opening"
			$1 "$dirs/$dir"
		fi
	fi
	exit 0
}

fuzzfunc() {
    local dirs="$2"
	local dir=$(ls "$2" | fzf)
	if [ -n "$dir" ]; then
		if [ -d "$dirs/$dir" ]; then
			echo "$dirs/$dir exists offline. Now opening..."
			$1 "$dirs/$dir"
			exit 0
		# else
		# 	echo "$dirs/$dir not found offline. Now Cloning:"
		# 	git clone https://github.com/spintlyinc/$dir.git $dirs/$dir
			# $1 "$dirs/$dir"
		fi
	fi
}

deploy() {
	local jarfile="/home/brian/Documents/os-scripts/jenkins-cli.jar"

	local l1=$(cat /home/brian/Documents/os-scripts/file | fzf)
	# echo $l1
	# local l2=$(java -jar $jarfile -auth $JENKINS_USER_TOKEN_8885 -s http://localhost:8885/ list-jobs "$l1" | fzf)
	# echo $l2
	# local l3=$(java -jar $jarfile -auth $JENKINS_USER_TOKEN_8885 -s http://localhost:8885/ list-jobs "$l1/$l2" | fzf)
	# 	echo $l3
	# local l4=$(java -jar $jarfile -auth $JENKINS_USER_TOKEN_8885 -s http://localhost:8885/ list-jobs "$l1/$l2/$l3" | fzf)
	# 	echo $l4
	# if [ -n "$dir" ]; then
	# 	if [ -d "$dirs/$dir" ]; then
	# 		echo "$dirs/$dir exists offline. Now opening"
	# 		$1 "$dirs/$dir"
	# 	else
	# 		echo "$dirs/$dir not found offline. Now Cloning:"
	# 		git clone https://github.com/spintlyinc/$dir.git $dirs/$dir
	# 		echo "Now opening"
	# 		$1 "$dirs/$dir"
	# 	fi
	# fi
}
alias dep='deploy'

fuzzwref(){
	if [ "$1" == refresh ]; then
		echo "Refreshing local repository list..."
		/home/brian/Documents/os-scripts/refresh_repos.sh
	else
		fuzz code Documents/repos
		# exit 1
	fi
}

# Create an alias for the code_dirs function
# alias repos="fuzz code Documents/repos/"
alias repos="fuzzwref"
# alias docs="fuzz nautilus Documents/"


# Docker commands

alias docker='sudo docker'

# Git Commnands

gap() {
	max_attempts=5
	current_attempt=0
	if [ -d .git ]; then
		if [ -n "$(git status --porcelain)" ]; then
			current_branch=$(git branch --show-current)
			if [ -n "$1" ] && [ -n "$2" ]; then
				if [ "$current_branch" == "$1" ]; then
					# if ping -c 2 8.8.8.8 &> /dev/null; then
						# echo "Git Pull:"
						# git pull
						git add .
						echo -e "\nGit Add: Done"
						echo -e "\nGit Commit:"
						git commit -m "$2"
						echo -e "\nGit Push: "
						while [ $current_attempt -lt $max_attempts ]; do
							((current_attempt++))
							
							git push origin $1 #|| echo "[ERROR] Failed to push to repository." && echo -n "gpo" | xclip -selection clipboard

							if [ $? -eq 0 ]; then
								echo -e "\n[SUCCESS] Git Push [$1]: $2\n" | lolcat
								date
								break
							else
								echo "[Retrying: $current_attempt] Git Push"
								# sleep 1
							fi
						done

						if [ $current_attempt -eq $max_attempts ]; then
							echo "Maximum number of attempts reached. Exiting."
							zenity --warning --text="Maximum number of attempts reached. Push Failed"
						fi
					# else
					# 	echo -e "[OFFLINE] Internet unavailable. Skipping push."
					# 	zenity --warning --text="Internet unavailable. Skipping push."
					# fi
				else
					echo -e "[ERROR] Pushing to Wrong branch: $current_branch =/= $1"
					echo -n "gap $current_branch \"\"" | xclip -selection clipboard
					zenity --warning --text="[ERROR] Pushing to Wrong branch: $current_branch =/= $1"
				fi
			else
				if [ -d .git ]; then
					echo -e ""
					git status
				fi
				echo -e "\n[USAGE] gap $current_branch \"Commit message\"\n"
				echo -n "gap $current_branch \"\"" | xclip -selection clipboard
			fi
		else
			echo -e "[SKIPPING] There are no changes in the repository."
			# add handling for gpo if gp fails lah
		fi
	else
		echo "[ERROR] Command Should be run from inside a git repository."
	fi
}

gas() {
	current_branch=$(git branch --show-current)
	git_url=$(git config --get remote.origin.url)
	echo -e "Origin: $git_url"
	if [ ! "$1" == "-y" ];then
		echo -e ""
		read -p "Refreshing local repository. Continue? (Y/N): " confirm 
	fi
	if  [[ $confirm == [yY] || $confirm == [yY][eE][sS] || "$1" == "-y" ]];then
		echo -e "\nRepository will now be cleansed..."
		rm -rf .[^.]* *
		echo -e "Cleared repository."
		echo -e "Cloning repository...\n"
		git clone $git_url .
		echo -e "\nRepository refreshed successfully.\n"
		git checkout $current_branch
	else
		echo -e "\nCancelled refreshing repository."
	fi
}

alias gs='git status'
alias ga='git add .'
alias gc='git checkout'
alias gr='git rm'
alias grh='git reset --hard'
alias gp='git pull'
alias gl='git log'
alias gcl='git clone'
alias gpo='git push origin'
alias gish="git stash"
alias gap='gap' #$1:branch #$2:commit-message
alias gas='gas' #-y: for no approval
alias gprf='git config pull.rebase false'
# GPG commands

# alias gengpg='/home/brian/Documents/os-scripts/gpg_generate.sh'
# old do not use. use sops developer keys insteas
# Visual code Commands

open_code_dir() {
	# repo_path="$1"
	default_path="/home/brian/Documents/repos"
	repo_path="$default_path/$1"
    if [ -n "$2" ]; then
        code "$repo_path"
        git --git-dir="${repo_path}.git" --work-tree="$repo_path" checkout $2
	# git --git-dir="${repo_path}.git" --work-tree="$repo_path" pull
	exit
    else
        code "$repo_path"
	exit
    fi
}

alias envc='open_code_dir spintly-environment-configs/'
alias jenc='open_code_dir spintly-jenkins-configs/'
alias drec='open_code_dir disaster-recovery-spintly/'

# Jenkins Commands

jenkinslint() {
	if [ -n "$1" ]; then
		curl --user $JENKINS_USER_PASS_8885 -X POST -F "jenkinsfile=<$1" http://localhost:8885/pipeline-model-converter/validate
	else
		curl --user $JENKINS_USER_PASS_8885 -X POST -F "jenkinsfile=<Jenkinsfile" http://localhost:8885/pipeline-model-converter/validate
	fi
}
alias jenkinslint='jenkinslint'

# Desktop commands

desktop() {
	if [ -n "$1" ]; then
		nautilus /home/brian/Documents/$1
		exit
	else
		nautilus /home/brian/Documents/
		exit
	fi
}

alias desktop='desktop'
