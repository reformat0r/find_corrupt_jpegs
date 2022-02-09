#!/bin/bash

#
# https://github.com/reformat0r/find_corrupt_jpegs
# raphael@gonku.de
#

if (( $# < 2 )); then
    echo "Finds JPEG-files that are corrupt and lack an End-Of-Image marker (for example due to a partial / failed download)."
    echo ""
    echo "Usage:"
    echo "./find_corrupt_jpegs.sh outfile.txt some_dir another_dir photos_*_2020 [...]"
    exit 0
fi

shopt -s nullglob

out_file=$1; shift
tput civis


readonly TERMINAL_COLS=`tput cols`
readonly BAR_WIDTH=$((TERMINAL_COLS<50?TERMINAL_COLS:50))
BAR_BLOCKS=$((BAR_WIDTH-19))

pblocks_done()       { printf " "; for ((done=0; done<$blocks_done; done++)); do printf "▇"; done }
pblocks_remaining()  { for ((blocks_remaining=0; blocks_remaining<$BAR_BLOCKS-$blocks_done; blocks_remaining++)); do printf " "; done }
ppercentage()        { printf "| %03s%%" $processed_percentage; }
pbroken()            { printf " - %s broken" $broken; }
clear_line()         { printf "\r"; }

files=()
for dir; do
    for file in $dir/*.jp*g; do
        files+=("$file")
    done
done

total=${#files[@]}
processed=0
processed_percentage=0
broken=0

total_digits=${#total}
BAR_BLOCKS=$((BAR_BLOCKS-total_digits)) # leave space for pbroken()

for file in "${files[@]}"
do
        tailbytes=`tail -c2 "$file" | xxd -ps`
        if  [[ -z $tailbytes || $tailbytes  != 'ffd9' ]]; then # Expect EOI
            echo "$file" >> "$out_file"
            broken=$((broken+1))
        fi

        processed=$((processed+1))
        processed_percentage=$(((processed*100/total*100)/100))
        blocks_done=$((BAR_BLOCKS*processed_percentage/100))

        clear_line; pblocks_done; pblocks_remaining; ppercentage; pbroken
done
printf "\n";
