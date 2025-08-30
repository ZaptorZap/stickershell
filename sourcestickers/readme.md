Stickers graciously provided by @msnmuffin on Discord (contacted thru the [*Mario Kart World* Discord server](https://discord.com/servers/mario-kart-world-1120933619591020574))

They have been processed with:
```bash
convert $page -alpha off -fuzz 8% -fill none -draw "matte 0,0 floodfill" \( +clone -alpha extract -blur 0x2 -level 50x100% \) -alpha off -compose copy_opacity -composite work/pages/page${page:15:-4}.png
```
> [!CAUTION]
> The crux of this project requires that you compare **against the above command**. If you figure out a better method, you should re-process **the original images** inside `MKWStickers.zip`.

Afterwhich, every 32nd sticker, starting with `57.png`, has been proceesed separately with a stub of
```bash
convert $target -fill magenta -draw 'rectangle 0,158 51,203' -transparent magenta -background none -resize 172x168^ -gravity center -extent 207x203 t-temp.png
```
