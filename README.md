# draft-assets

Images for [draft-bot](https://github.com/EnryuVGC/draft-bot). Character data (stats) lives in the bot repo under `data/`.

- `images/<series>/<id>.jpg`: one portrait per character, named by its id.
  - Base characters: 4 digits, zero-padded (`images/naruto/0001.jpg`)
  - Forms: the form id as-is (`images/naruto/10001.jpg`)
- Keep images about 800px tall, portrait 3:4, JPG under ~200 KB.

## Adding images

Every image goes through an AI upscaler before it's added:

1. Put the original in `raw/` (ignored by Git), named by id.
2. Upscale with an anime model: Real-ESRGAN (`realesrgan-ncnn-vulkan`, model `realesr-animevideov3`), or the Upscayl app.
3. Crop to a 3:4 portrait.
4. Resize to about 800px tall and save as JPG under ~200 KB.
5. Save to `images/<series>/<id>.jpg`.

## Collectible card art (packs)

Collectible cards use their own art, separate from the match portraits, so every card feels unique.

- `images/packs/<SET>/<NNN>.jpg`: art for card number NNN of a set, 3 digits (`images/packs/WOF/012.jpg` is card `WOF · 012/045`).
  Card numbers and names are in the bot repo, `data/collectibles/<set>.json`.
- 750px wide, any shape, JPG under ~300 KB. Nothing is cropped from the sides: tall art (about 5:7) fills the whole card, wider art fills the top of the card and fades into the dark name panel. Portrait images with some space above the head look best.

To add art: put the original in `raw/packs/<SET>/` named by card number (`12.png` or `012.png`), then run
`./process-pack.sh WOF`. It upscales (same Real-ESRGAN model), resizes to 750px wide and saves to `images/packs/<SET>/`.
To redo a card, delete its JPG and run the script again.
