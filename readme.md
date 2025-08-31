# Sticker Shell
Compare your [Mario Kart World](https://www.nintendo.com/us/gaming-systems/switch-2/featured-games/mario-kart-world/) sticker collection against a good dump of **100%** completion in a matter of minutes. This is a finnicky process automated with ImageMagick's [compare](https://imagemagick.org/script/compare.php) function. Your completion state is output as simple text files, and as a JSON save for https://www.mktools.io/ (I.E. [BamisWasTaken/mkworld-checklist](https://github.com/BamisWasTaken/mkworld-checklist)) to import, giving you a proper map to collect all P-Switches and ? Panels with ease.

## Requirements
This project was developed on Linux. I would expect this to work on Windows (with E.G. [Cygwin](https://www.cygwin.com/) or [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)), but don't expect any support from me should you decide to do that. Exact requirements below:
* You must have beaten the Special Cup first to unlock a reliable foundation of stickers. This is a very dependable requirement, so I don't feel remorse for requiring it.
* [Bash](https://www.gnu.org/software/bash/)
* [ImageMagick](https://imagemagick.org/)
> [!IMPORTANT]
> On Debian, `imagemagick compare` is exclusively aliased to `compare`. There is no `imagemagick` command on my system. I don't really know why they decided to do this or what it looks like on other distributions, but I'm not very motivated to try to proactively patch that. Just make that alias yourself or search and replace in the shell if this is a problem.
* [jq](https://jqlang.org/) (not strictly necessary but you know)

## Instructions
1. Ensure *HDR Output* is disabled in System Settings→Display.
> [!WARNING]
> This step is of **paramount importance**! HDR acts inconsistently, and you must have <ins>as identical a capture</ins> as given in this project.
2. Open Mario Kart World on your Switch 2.
3. Navigate to the sticker collection (bottom/left icon on main menu)
4. Ensure all stickers have been hovered over and **no red {!} label is present on any page**. <ins>This could throw off detection.</ins>
5. Press Ⓧ(X) to sort by shape. The first page will be of stage emblems.
6. Move your cursor to the **bottom left sticker**.
7. Select Shy Guy Bazaar as your ✅ sticker.
  * This is considered important, as to not throw off detection later.
8. Press the ⧇ Capture button, then move to the next page with R(right shoulder button)
  * Repeat until **all pages** are captured. Timing doesn't matter much, so long as the stickers are fully opaque. (a quick peek seemed to confirm they are no longer moving, once opaque)
9. With all pages accounted for, go to System Settings→Data Management→Manage Screenshots and Videos
10. Clone this repo (`git clone https://github.com/ZaptorZap/stickershell.git` • or [download as .zip](https://github.com/ZaptorZap/stickershell/archive/refs/heads/main.zip))
11. Plug your Switch 2 into your computer with a USB-C cable. Press "Copy to PC over USB"
  * Again, this is considered particularly important. *Upload to Smart Device* introduces compression artifacts tangible enough for me to worry about this approach working. Besides, it's easier to drag 20 pictures over all at once instead of one-by-one individually with the NSO app.
12. With your Switch 2 connected, drag every screenshot of the sticker collection into `userstickers/`
13. Rename the screenshots (in page order, of course) to `1.jpg`, `2.jpg`, `3.jpg`, etc 
  * On KDE/Dolphin, this is very simple: sort by date modified/name(in the proper direction), then `CTRL+A`→`F2`. Bulk rename to `#`
14. Assuming all is good, run the script in the repo's directory. By default, this will split your image to `work/` and compare to the known stickers in `sourcestickers/`
  * A save file for https://www.mktools.io/ will be generated as `mktools-save-shelled.json`.
  * Text files `clearedstickers.txt` and `missingstickers.txt` will be generated.

It might work flawlessly first try. It might get fussy over something. This is kind of where you might have to fiddle with the script itself. For example, you can add an entry to `$badstickers` on line 56. You can exclusively re-compare (and save tons of time) with `./stickershell comparestickers`. You may want to consider piping output with `| tee log.txt` for more diagnostics.

### Notes/Limitations
* Unfortunately, Peach Medallions aren't deterministic. They're looped in with all the other `(random)` stickers with total impunity, so you'll still have to re-visit every single location. (or just learn [the speedrun](https://www.speedrun.com/mkworld?h=free-roam-all-peach-medallions&x=w206yzj2-wle35er8.le2ggokl) or something)
* You might want to ensure the **end** of your sticker collection is properly sorted. Mario Circuit's stickers in particular are anguishing to process as most of them are 1-1 identical, yet have tons of jagged edges that IM really hates. I would be truly screwed if they weren't at the *very end* of the sticker collection.

### Postscript
This open world is truly worth experiencing, but every single step to actually playing all it has to offer is covered in absolutely absurd friction. There's a compelling gameplay loop with P-Switches when they're directly next to each other or lead into each other, but it feels like not a lot of planning went into making absolutely sure that happens. It's well worth playing with no guidance for a good 1-2 dozen hours, but then you *really* start to run into the void of gray P-Switches(or at least, I did). Reloading the game over and over with the hope of the main menu spawning you next to a binocular isn't even viable.

I just can't believe how much there is here with next to no expectation of you seeing it all. **P-Switch Missions aren't Koroks.** It took them nearly **2 months** to add the *tiniest of recognition* that you even did everything in the open world. I just can't believe they fumbled this; that QA didn't care here. I truly hope this repo ages poorly and this becomes just as easy/reasonable to 100% as Donkey Kong Bananza. (worst case scenario, an open world DLC island actually comes out and I have to revisit this in a year....)

In any case, it seems like the community provides where Nintendon't when it comes to this issue, just like with "Lap-Type Courses" being "erased" from online play. Shoutouts to everyone else who figured out the databases of where everything is. I don't expect to make a big splash with this tool, but I'm happy I saw it through to the end.
