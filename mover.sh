#/usr/bin/env sh
for f in targets/*.target.sh; do
  name="$(basename $f | cut -d '.' -f 1)"
  cp -v "$f" "./$name/target.sh"
done
