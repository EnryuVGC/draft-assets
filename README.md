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
