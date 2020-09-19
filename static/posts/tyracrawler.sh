#!/bin/bash

HEADERS=(
'-H' "X-Parse-Session-Token: r:e5b521dba5237e2afde777f51e6d1786"
'-H' "X-Parse-Application-Id: ydRCutPl8nhiTSRlam0gT5SEqFtuW6N2"
'-H' "X-Parse-App-Build-Version: 1354"
'-H' "X-Parse-App-Display-Version: 1.3.5.4"
'-H' "X-Parse-OS-Version: 8.0.0"
'-H' "User-Agent: Parse Android SDK API Level 26"
'-H' "X-Parse-Installation-Id: b8d00626-4895-47d4-b686-a620a59cc603"
'-H' "X-Parse-Client-Key: Dl4sl9mMqnfjxlmH5oZ0Qe3WJajlg3PU"
'-H' "Content-Type: application/json"
'-H' "Host: login.tyra-appen.se"
'-H' "Connection: Keep-Alive"
'-H' "Accept-Encoding: gzip"
)



for i in $(curl -s "${HEADERS[@]}" -X POST 'https://login.tyra-appen.se/parse/classes/notifications' --data-binary '{"include":"user.user_extra,kid_owner.departmentPointer,extra_info,performer.user,notice_creator,origin.user.user_extra,origin.kid","limit":"200","where":"{\"school\":{\"$in\":[\"Kungsholmen International\"]},\"user\":{\"__type\":\"Pointer\",\"className\":\"_User\",\"objectId\":\"Q047ojSpyj\"}}","order":"-createdAt","_method":"GET"}' | jq -r ".results[].origin[0].objectId"); do
    echo $i
    if [[ $i != "null" ]]; then
        curl -o json/$i.json -s "${HEADERS[@]}" -X POST 'https://login.tyra-appen.se/parse/classes/blogg_doc' --data-binary '{"include":"images,blogg_department,blogg_author,doc_tags,curriculums,author.user","limit":"10","where":"{\"blogg_content\":{\"$exists\":true},\"blogg_kids_connected\":{\"$in\":[{\"__type\":\"Pointer\",\"className\":\"kids\",\"objectId\":\"LHm9kpUrZY\"}]},\"objectId\":\"'$i'\",\"draft\":{\"$ne\":true}}","order":"-publish_date","_method":"GET"}'
        dt=$(cat json/$i.json |  jq -r '.results[].images[0].createdAt')
        for u in $(cat json/$i.json | jq -r ".results[].images[].image.url"); do
            if [ ! -f images/${dt}_${i}_$(basename $u).jpg ]; then
                echo ${dt}_${i}_$(basename $u)
                curl -s -o images/${dt}_${i}_$(basename $u).jpg $u
            fi
            touch -d "${dt}" images/${dt}_${i}_$(basename $u).jpg
        done
        for u in $(cat json/$i.json | jq -r ".results[].images[].video_file.url"); do
            if [ ! "$u" == "null" ]; then
                if [ ! -f images/${dt}_${i}_$(basename $u).mp4 ]; then
                    echo ${dt}_${i}_$(basename $u)
                    curl -s -o images/${dt}_${i}_$(basename $u).mp4 $u
                fi
                touch -d "${dt}" images/${dt}_${i}_$(basename $u).mp4
            fi
        done
    fi
done