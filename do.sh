#!/bin/bash

ES_URL="http://localhost:9200/"
S3_BUCKET="cognetive-store"
AWS_ACCESS_KEY_ID="GJMGkDfzU3Exndf4IksJ"
AWS_SECRET_ACCESS_KEY="eCV5ad9esc3QIA2LF7wG1UgCrWk6bjuHBLUm3gJk"
AWS_DEFAULT_REGION="us-geo"
AWS_ENDPOINT="http://s3-api.us-geo.objectstorage.softlayer.net"
export ES_URL S3_BUCKET AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION AWS_ENDPOINT

CURRENT_DATE=`date "+%Y.%m.%d"`

curl ${ES_URL}_cat/indices -s 2>&1 | grep 'logstash-cleversafe' | grep -v ${CURRENT_DATE} > .es_index_list
while IFS='' read -r LINE || [[  -n "$LINE" ]]; do
  echo ${LINE} | grep -q '^close'
  IS_CLOSED="$?"
  if [ "${IS_CLOSED}" -ne 0 ]; then
    #ignore closed indices for now
    INDEX_NAME=`echo ${LINE} | awk '{print $3}'`
    ES_INDEX="${INDEX_NAME}"
    S3_KEY="${INDEX_NAME}-cr.gz"
    export ES_INDEX S3_KEY
    /opt/ruby2/bin/ruby export.rb
  fi
done < ".es_index_list"
