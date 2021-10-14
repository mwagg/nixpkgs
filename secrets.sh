#!/usr/bin/env bash
set -e

trap 'rm -rf /tmp/key' EXIT

mkdir -p ~/.ssh

export BW_SESSION="$(bw login --raw)"
export BW_SESSION="$(bw unlock --raw)"

bw get attachment 9p6xj344ur9dce8y93msj2gsstem3ml3 --itemid dcedc674-089c-4f7f-a7d1-aa8e00b8b5ed --raw > /tmp/key
gpg --import /tmp/key
bw get attachment qgarlw2wotzg18s4etkyt3jjo47dsnfh --itemid dcedc674-089c-4f7f-a7d1-aa8e00b8b5ed --raw | gpg --import-ownertrust

function get_secret {
    item_id=$1
    attachment_id=$2
    file=$3

    if [[ ! -f "$3" ]]; then
        bw get attachment "$attachment_id" --itemid "$item_id" --output "$file"
    else
        echo "Skipping $3 as it already exists"
    fi
}

get_secret e93fa440-324a-419e-acd4-aa7300d8ed5d iazv38i80dl0gq9ctn80p0zcoizlaglx ~/.ssh/eporta.pub
get_secret e93fa440-324a-419e-acd4-aa7300d8ed5d chocg8j9jn0ce67leh3u8my7ybp24d73 ~/.ssh/eporta

get_secret 2b3bfe9d-ef76-4bba-9a27-a80000d36e86 wvb3nx6m5evq5qgk76li684hqv34zksi ~/.ssh/id_rsa
get_secret 2b3bfe9d-ef76-4bba-9a27-a80000d36e86 2gnovdize9kfq9maa0g1oenj9fn823wt ~/.ssh/id_rsa.pub
get_secret 2b3bfe9d-ef76-4bba-9a27-a80000d36e86 w6zub46sfg8be24gohor5mnakx0m6kn7 ~/.ssh/config

mkdir -p ~/.config/aws
get_secret 38bbeb4e-5e9f-4e94-8cb6-aa4700e960d1 3hdt0ik26ch8m8qf22g797utceak2qa6 ~/.aws/config
get_secret 38bbeb4e-5e9f-4e94-8cb6-aa4700e960d1 ihy2nzu81t823penxn2wx6wd9lc36jjg ~/.aws/credentials

get_secret e0c16ca1-0baf-49a9-90d5-aa8e00a625c3 lwwi495agi0wh66uk2xd5wbg9yyp7mip ~/.terraformrc


chmod 600 ~/.ssh/*
