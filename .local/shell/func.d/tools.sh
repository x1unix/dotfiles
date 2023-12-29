myip() {
  ip a | grep LOWER_UP | grep -v LOOPBACK | awk '{print substr($2,1,length($2)-1)}' | xargs ifconfig | grep inet | awk '{print $2}'
}
video2gif() {
  # see: https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg/
  local src=$1
  local dest="$1.gif"
  echo "$1 => $dest"
  ffmpeg -i $1 -loop 1 -filter_complex "[0:v] fps=${fps:=12},split [a][b];[a] palettegen [p];[b][p] paletteuse" -f gif $dest
}

