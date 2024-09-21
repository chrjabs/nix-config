#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq httpie

img_url=$1
img_name=$2
img_list=$3
if [[ $3 -lt 3 ]]; then
    img_list="./list.json"
fi

image="$(echo "$1" | rev | cut -d '/' -f1 | rev | cut -d '.' -f1)"
clientid="0c2b2b57cdbe5d8"

image=$(https api.imgur.com/3/image/$image Authorization:"Client-ID $clientid" | jq -r '.data | "\(.type)|\(.id)"')

name=$2
ext=$(echo $image | cut -d '|' -f 1 | cut -d '/' -f 2)
id=$(echo $image | cut -d '|' -f 2)
sha256=$(nix-prefetch-url https://i.imgur.com/$id.$ext)

tmpfile=$(mktemp add-image-tmp-list-XXXXXXXX)

cat $img_list | jq \
    --arg name "$name" \
    --arg ext "$ext" \
    --arg id "$id" \
    --arg sha256 "$sha256" \
    '. += [{"name": $name, "ext": $ext, "id": $id, "sha256": $sha256}]' > $tmpfile

if [ $? == 0 ]; then
    mv $tmpfile $img_list
fi
