#!/bin/zsh
# usage: ./process-pack.sh WOF   processes every raw/packs/<SET>/<number>.<ext> that has no images/packs/<SET>/<NNN>.jpg yet
# Collectible card art: AI-upscaled and resized to the card's width (750px), never cropped.
# The bot fits the art on the card: tall art fills it, wider art fills the top and fades into the dark name panel.
set -e
set_code=${1:?usage: ./process-pack.sh <SET CODE>}
set_code=${set_code:u}
cd ${0:A:h}
RE=~/tools/realesrgan
mkdir -p raw/packs/$set_code images/packs/$set_code
cards=$(python3 -I -c 'import json,sys; print(len(json.load(open(sys.argv[1]))["cards"]))' ~/Desktop/Draft/data/collectibles/${set_code:l}.json)

for src in raw/packs/$set_code/*.(png|jpg|jpeg|webp)(N); do
  name=${src:t:r}
  [[ $name == <-> ]] || continue
  num=$(( 10#$name ))
  (( num >= 1 && num <= cards )) || { echo "skip $src: $set_code has cards 1-$cards"; continue }
  key=$(printf %03d $num)
  out=images/packs/$set_code/$key.jpg
  [[ -f $out ]] && continue
  tmp=raw/packs/$set_code/$key

  "$RE/realesrgan-ncnn-vulkan" -i "$src" -o $tmp-up.png -n realesr-animevideov3 -s 2 -m "$RE/models" >/dev/null 2>&1
  for q in 85 75 65; do   # step quality down until the JPG is under ~300 KB
    sips --resampleWidth 750 -s format jpeg -s formatOptions $q $tmp-up.png --out $out >/dev/null
    (( $(stat -f%z $out) <= 307200 )) && break
  done
  rm $tmp-up.png
  echo "$out $(( $(stat -f%z $out) / 1024 ))KB"
done
