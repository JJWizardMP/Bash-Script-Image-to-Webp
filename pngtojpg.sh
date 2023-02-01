#!/bin/bash

S3="s3://spaceohrtest/assets/"
ENDPOINT="https://spaceohrtest.sfo2.cdn.digitaloceanspaces.com/"


downloadImgs(){
    space=$( echo "${1}" | cut -d '/' -f1-3 )
    while read -r line;
    do
        # split path
        img=$( echo $line | tr '/' ' ' | grep -E -o "[_0-9A-Za-z-]*\.(jpg|png|jpeg)$" | sed -E 's/(jpg|png|jpeg)/jpg/g' )
        path=$( echo $line | tr '/' ' ' | sed -E "s/[_0-9A-Za-z-]*\.(jpg|png|jpeg)$//g" | tr ' ' '/' )
        thumb=$( echo $line | sed 's/\./-thumbnail\./g' )
        thumbpath=$( echo $line | sed 's/\.png/-thumbnail\.jpg/g' )
        # download images
        wget -P "${path}" "${2}/${line}"
        wget -P "${path}" "${2}/${thumb}"
        # transform all formats to webp
        convert "${line}" -quality 70 "${path}${img}"
        convert "${thumb}" -quality 70 "${thumbpath}"
        #cwebp -q 70 "${line}" -o "${path}${img}"
        # upload to DO
        #s3cmd put "${path}${img}" "${space}/${path}" --acl-public
        #s3cmd put "${path}${img}" "${space}/${path}" --acl-public
    done < referencespng
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

downloadImgs $S3 $ENDPOINT

exit 0