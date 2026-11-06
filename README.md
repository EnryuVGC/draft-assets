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

## Collectible cards (packs)

`images/packs/<SET>/<NNN>.jpg` are the **finished collectible cards**, pre-rendered by the bot's card renderer;
the bot sends them as they are. Card numbers, names and rarities are in the bot repo, `data/collectibles/<set>.json`
(`images/packs/WOF/012.jpg` is card 12 of Will of Fire).

Each card is drawn from its own source art when it has some, otherwise from the character's match portrait.
Source art is kept locally in `raw/packs/<SET>/art/` (ignored by Git, like all of `raw/`).

To add or replace art: put the original in `raw/packs/<SET>/` named by card number (`12.png` or `012.png`), then run
`./process-pack.sh WOF`. It AI-upscales the art (same Real-ESRGAN model), resizes it to 750px wide without cropping,
saves it to `raw/packs/<SET>/art/`, and re-renders all of the set's cards into `images/packs/<SET>/`.
To redo a card's art, delete `raw/packs/<SET>/art/<NNN>.jpg` and run the script again.
Portrait images with some space above the head look best: tall art fills the whole card, wider art fills the top and
fades into the name panel.

**Booster pack picture:** `images/packs/<SET>/pack.jpg`. Put the pack's key art in `raw/packs/<SET>/pack.png`;
art on a plain white background works best, since the white around the characters is cut out. The pack's foil colours
are `pack_colors` in the set's JSON. `./process-pack.sh <SET>` draws it along with the cards.
