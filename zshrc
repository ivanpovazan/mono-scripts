function parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1) /p'
}
setopt PROMPT_SUBST ; PS1='%B%F{cyan}%n@%m%f %F{blue}%~%f %F{green}$(parse_git_branch)%f%F{220}$%f%b '