checknpull() {
  git checkout $1 && git pull
}

pubbranch() {
  git push --set-upstream origin $(cbranch)
}

