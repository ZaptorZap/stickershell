#!/bin/bash

# ↓ constants, offset added at runtime
gridwidth="208" # original offset: 129
gridheight="205" # original offset: 67

splitwork() {
realpages=(./userstickers/*.jpg) # this array kinda sucks and isn't dependable—I.E. doesn't *begin* at 1.jpg. only use it as a count
IFS=$'\n' ; sortedpages=($(sort -t'/' -k3n <<<"${realpages[*]}")) ; unset IFS
realpagecountnumber=${#realpages[@]}
echo "splitting stickers to be compared. this could take a while"

for page in "${sortedpages[@]}" ; do
	echo "starting ${page:15:-4} (of $realpagecountnumber pages)"
	convert $page -alpha off -fuzz 8% -fill none -draw "matte 0,0 floodfill" \( +clone -alpha extract -blur 0x2 -level 50x100% \) -alpha off -compose copy_opacity -composite work/pages/page${page:15:-4}.png # WARNING this is not to be edited without consulting sourcestickers/readme.md
	for row in {1..4} ; do
		for column in {1..8} ; do
			stickernumber=$((column+(row*8)+(${page:15:-4}*32)-40))
			convert work/pages/page${page:15:-4}.png -crop ${gridwidth}x${gridheight}+$((gridwidth*column-78))+$((gridheight*row-136)) work/$stickernumber.png
			echo "sticker $stickernumber/$((32*realpagecountnumber)) ready"
			if [[ "${sortedpages[-1]}" = "$page" ]] ; then
				echo "final page: checking for blank sticker"
				errantpixels=$(compare -fuzz 10% -metric ae work/$stickernumber.png sourcestickers/blank.png null: 2>&1)
				if [[ $errantpixels -lt 2000 ]] ; then # the ↗selected arrow↗ works out to about ~1500 pixels, whereas blank.png is only ~170 pixels wrong
					echo "blank sticker found, returning"
					return
				fi
			fi
		done
	done
done
}

comparestickers() {
realtargets=(./work/*.png) # NOTE line 9 still relevant
IFS=$'\n' ; sortedtargets=($(sort -t'/' -k3n <<<"${realtargets[*]}")) ; unset IFS
realtargetcountnumber=${#realtargets[@]}
echo "preliminary special world/shape sort check:"

for target in "${sortedtargets[@]:0:16}" ; do
errantpixels=$(compare -fuzz 10% -metric ae ./sourcestickers/${target:7} $target null: 2>&1)
if [[ $errantpixels -lt 3200 ]] ; then # about 8% incorrect
	echo "${target:7} passes ($errantpixels<3000)"
else
	fold -w$COLUMNS --spaces <<<"something's wrong here. either you aren't sorted properly, these aren't captured correctly (take ingame screenshots—upload to your computer via USB), or you haven't finished the Special Cup. (difference of $errantpixels pixels)"
	fold -w$COLUMNS --spaces "if it is the latter, i'm not supporting this case. go finish Special Cup, it won't take that long and you can't get lost doing it"
	exit 1
fi
done

echo "skipping first 30/last 41, since they're confirmed. starting the real work now"
rm clearedstickers.txt missingstickers.txt
printf "You raced in the Special Cup!\n%.0s" {1..30} >> clearedstickers.txt
source=31
declare -g -a found
badstickers=(395 944 1005 1006 1007 1008 1009 1010 1011 1012) # these are, of course, those contained in sourcestickers/. 1st one frequently gets a significant amount of its white blown off. 2nd one was just being annoying. everything after that is a part of Mario Circuit. (and is therefore very annoying for some reason)

for target in "${sortedtargets[@]:30:1014}" ; do
	errortolerance=4000
	fuzzfactor=10
	if [ $(((${target:7:-4}-25)%32)) = 0 ] ; then # this is a selected sticker→more leniency needed
		convert $target -fill magenta -draw 'rectangle 0,158 51,203' -transparent magenta -background none -resize 172x168^ -gravity center -extent 207x203 t-temp.png
		# WARNING ↑ this is attrocious. i've tried to scan and to the best of my abilities no pixel of magenta exists in any stickers. in any case this still isn't even remotely 1-1 with whatever's happening ingame so i'm just going out on a whim and saying 5000 pixels of difference is fine enough™
		target=t-temp.png
		errortolerance=5000
		fuzzfactor=15
	fi
	if [ $((($source-25)%32)) = 0 ] ; then
		errortolerance=5000
		fuzzfactor=15
		# ↑ these are pre-rendered. it has to be; nothing's changing this back to its natural form after the loop ends and i'm not braining my way into a solution. so, well, hope it just works. wishful thinking and all
	fi
	echo "testing ${target:7}"
	while true ; do
		if [ $((($source-25)%32)) = 0 ] ; then
			errortolerance=5000
			fuzzfactor=15
			# ↑ these are pre-rendered. it has to be; nothing's changing this back to its natural form after the loop ends and i'm not braining my way into a solution. so, well, hope it just works. wishful thinking and all
		fi
		if printf '%s\n' "${badstickers[@]}" | grep -F -x -- $source ; then
			errortolerance=5300
		fi
		missiontitle=$(head -n $source stickerdatabase.txt | tail -n -1)
		errantpixels=$(compare -fuzz $fuzzfactor% -metric ae sourcestickers/$source.png $target null: 2>&1)
		if [[ $errantpixels -lt $errortolerance ]] ; then
			echo "found: $missiontitle ($errantpixels<$errortolerance)"
			echo "$missiontitle ($errantpixels<$errortolerance errant pixels)" >> clearedstickers.txt
			found+=("$(($source-1))")
			let source++
			if [ $source = 1015 ] ; then
				return
			fi
			break
		else
			echo "missing: $missiontitle ($source.png $errantpixels<$errortolerance)"
			echo "$missiontitle ($errantpixels<$errortolerance errant pixels)" >> missingstickers.txt
			let source++
		fi
		if [ $source = 1015 ] ; then
			return
		fi
		if [ $errortolerance != 4000 ] ; then
			errortolerance=4000
		fi
	done
done

}

if [ -z $1 ] ; then
splitwork
comparestickers
printf -v joined '%s,' "${found[@]}"
jq --compact-output ".checklistModelStates[${joined%,}].checked=true" mktools-save-plain.json > mktools-save-shelled.json
rm t-temp.png
fi

if [ "$1" = "splitwork" ] ; then
splitwork
fi

if [ "$1" = "comparestickers" ] ; then
comparestickers
printf -v joined '%s,' "${found[@]}"
jq --compact-output ".checklistModelStates[${joined%,}].checked=true" mktools-save-plain.json > mktools-save-shelled.json
rm t-temp.png
fi
