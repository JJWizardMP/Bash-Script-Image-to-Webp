#!/bin/bash

S3="s3://spaceohrtest/assets/"
ENDPOINT="https://oasishoteles.sfo2.cdn.digitaloceanspaces.com/"

downloadCDNTree(){
    s3cmd ls "$1" --recursive | grep -E "\.(jpg|png|jpeg)$" | tr -s ' ' | cut -d ' ' -f4 | cut -d '/' -f4- > cdntree
}

downloadCDNTreeMP4(){
    s3cmd ls "$1" --recursive | grep -E "\.(mp4)$" | tr -s ' ' | cut -d ' ' -f4 | cut -d '/' -f4- > cdntreemp4
}

downloadImgs(){
    space=$( echo "${1}" | cut -d '/' -f1-3 )
    while read -r line;
    do
        # split path
        img=$( echo $line | tr '/' ' ' | grep -E -o "[_0-9A-Za-z-]*\.(jpg|png|jpeg)$" | sed -E 's/(jpg|png|jpeg)/webp/g' )
        path=$( echo $line | tr '/' ' ' | sed -E "s/[_0-9A-Za-z-]*\.(jpg|png|jpeg)$//g" | tr ' ' '/' )
        # download images
        wget -P "${path}" "${2}/${line}"
        # transform all formats to webp
        #cwebp -q 70 "${line}" -o "${path}${img}"
        # upload to DO
        #s3cmd put "${path}${img}" "${space}/${path}" --acl-public
    done < cdntree
}

downloadVideos(){
    space=$( echo "${1}" | cut -d '/' -f1-3 )
    while read -r line;
    do
        # split path
        vid=$( echo $line | tr '/' ' ' | grep -E -o "[_0-9A-Za-z-]*\.(mp4)$" | sed -E 's/(mp4)/webm/g' )
        path=$( echo $line | tr '/' ' ' | sed -E "s/[_0-9A-Za-z-]*\.(mp4)$//g" | tr ' ' '/' )
        # download images
        wget -P "${path}" "${2}/${line}"
        # transform all formats to webp
        #cwebp -q 70 "${line}" -o "${path}${vid}"
        # upload to DO
        #s3cmd put "${path}${vid}" "${space}/${path}" --acl-public
    done < cdntreemp4
}

transformImgs(){
    # transform all formats to webp
    dvx img:towebp --src ./assets/ --dist ./assets/
}

uploadImgs(){
    space=$( echo "${1}" | cut -d '/' -f1-3 )
    while read -r line;
    do
        # split path
        img=$( echo $line | tr '/' ' ' | grep -E -o "[_0-9A-Za-z-]*\.(jpg|png|jpeg)$" | sed -E 's/(jpg|png|jpeg)/webp/g' )
        path=$( echo $line | tr '/' ' ' | sed -E "s/[_0-9A-Za-z-]*\.(jpg|png|jpeg)$//g" | tr ' ' '/' )
        # upload to DO
        s3cmd put "${path}${img}" "${space}/${path}" --acl-public
    done < cdntree
}

deleteWebpDO(){
    s3cmd rm s3://spacename/name/of/file
    space=$( echo "${1}" | cut -d '/' -f1-3 )
    while read -r line;
    do
        # split path
        img=$( echo $line | tr '/' ' ' | grep -E -o "[_0-9A-Za-z-]*\.(jpg|png|jpeg)$" | sed -E 's/(jpg|png|jpeg)/webp/g' )
        path=$( echo $line | tr '/' ' ' | sed -E "s/[_0-9A-Za-z-]*\.(jpg|png|jpeg)$//g" | tr ' ' '/' )
        # delete webp
        s3cmd rm "${space}/${path}${img}"
    done < cdntree
}
# IMAGES
#####################
#downloadCDNTree $S3
#downloadImgs $S3 $ENDPOINT
#transformImgs
#uploadImgs $S3 $ENDPOINT
#deleteWebpDO $S3 $ENDPOINT
####################
# VIDEOS

downloadCDNTreeMP4 $S3

exit 0