checknpull() {
  git checkout $1 && git pull
}

pubbranch() {
  git push --set-upstream origin $(cbranch)
}

closebranch() {
  curbranch="$(git rev-parse --abbrev-ref HEAD)"
  git checkout "$1" && git pull
  git branch -D "$curbranch"
}

git-rename-branch() {
  if [ $# -ne 2 ]; then
    echo "Usage     : ${FUNCNAME[0]} <old branch name> <new branch name>"
    echo "Example   : ${FUNCNAME[0]} master release"
    return 1 
  fi

  git checkout "$1"
  git branch -m "$2"
  git push origin ":$1" "$2"
  git push origin -u "$2"
}
