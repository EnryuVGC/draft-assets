#!/bin/zsh
# usage: ./process-pack.sh WOF
# 1. processes every raw/packs/<SET>/<number>.<ext> that has no raw/packs/<SET>/art/<NNN>.jpg yet:
#    AI-upscaled and resized to 750px wide, never cropped (source art stays local, not committed)
# 2. renders the set's finished cards into images/packs/<SET>/<NNN>.jpg, which the bot sends as is
#    (cards without art use the match portrait)
set -e
set_code=${1:?usage: ./process-pack.sh <SET CODE>}
set_code=${set_code:u}
cd ${0:A:h}
ROOT=$PWD
RE=~/tools/realesrgan
BOT=~/Desktop/Draft
mkdir -p raw/packs/$set_code/art images/packs/$set_code
cards=$(python3 -I -c 'import json,sys; print(len(json.load(open(sys.argv[1]))["cards"]))' $BOT/data/collectibles/${set_code:l}.json)

for src in raw/packs/$set_code/*.(png|jpg|jpeg|webp)(N); do
  name=${src:t:r}
  [[ $name == <-> ]] || continue
  num=$(( 10#$name ))
  (( num >= 1 && num <= cards )) || { echo "skip $src: $set_code has cards 1-$cards"; continue }
  key=$(printf %03d $num)
  art=raw/packs/$set_code/art/$key.jpg
  [[ -f $art ]] && continue
  tmp=raw/packs/$set_code/$key

  "$RE/realesrgan-ncnn-vulkan" -i "$src" -o $tmp-up.png -n realesr-animevideov3 -s 2 -m "$RE/models" >/dev/null 2>&1
  for q in 85 75 65; do   # step quality down until the JPG is under ~300 KB
    sips --resampleWidth 750 -s format jpeg -s formatOptions $q $tmp-up.png --out $art >/dev/null
    (( $(stat -f%z $art) <= 307200 )) && break
  done
  rm $tmp-up.png
  echo "art $art $(( $(stat -f%z $art) / 1024 ))KB"
done

(cd $BOT && go run ./cmd/cards -set $set_code -assets $ROOT -out $ROOT/images/packs/$set_code >/dev/null)
echo "rendered $cards cards into images/packs/$set_code"
