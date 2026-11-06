#!/bin/zsh
# usage: ./process.sh [series]   processes every raw/<id>.<ext> that has no images/<series>/<id>.jpg yet
set -e
series=${1:-naruto}
cd ${0:A:h}
RE=~/tools/realesrgan
nocrop=(0031 0045 10006)   # ids kept at their original aspect ratio (resize only)
mkdir -p raw images/$series
# only ids that belong to this series (raw/ is shared across series)
ids=(${(f)"$(python3 -I -c 'import json,sys; [print("%04d" % c["id"]) for c in json.load(open(sys.argv[1]))]' ~/Desktop/Draft/data/$series.json)"})

for src in raw/*.(png|jpg|jpeg|webp)(N); do
  name=${src:t:r}
  [[ $name == <-> ]] || continue
  (( ${ids[(Ie)$name]} )) || continue
  out=images/$series/$name.jpg
  [[ -f $out ]] && continue

  "$RE/realesrgan-ncnn-vulkan" -i "$src" -o raw/$name-up.png -n realesr-animevideov3 -s 2 -m "$RE/models" >/dev/null 2>&1
  w=$(sips -g pixelWidth raw/$name-up.png | awk '/pixelWidth/{print $2}')
  h=$(sips -g pixelHeight raw/$name-up.png | awk '/pixelHeight/{print $2}')
  if (( w * 4 > h * 3 )); then cw=$(( h * 3 / 4 )); ch=$h; ox=$(( (w - cw) / 2 )); else cw=$w; ch=$(( w * 4 / 3 )); ox=0; fi
  if (( ${nocrop[(Ie)$name]} )); then cp raw/$name-up.png raw/$name-crop.png
  else sips -c $ch $cw --cropOffset 0 $ox raw/$name-up.png --out raw/$name-crop.png >/dev/null; fi
  sips --resampleHeight 800 -s format jpeg -s formatOptions 85 raw/$name-crop.png --out $out >/dev/null
  rm raw/$name-up.png raw/$name-crop.png
  echo "$out $(( $(stat -f%z $out) / 1024 ))KB"
done
