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

