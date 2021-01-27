#!/bin/bash

ELK_HOME=/home/elk
ES_HOME=$ELK_HOME/elasticsearch-7.10.1
sleepTime=10

function check() {
   counter=1
   SITE_NAME=$1
   URL=$2
   while [[ counter -lt 10 ]]; do
      rc=$(curl -sL -k -w "%{http_code}\n" $URL -o /dev/null)

      if [[ "$rc" == "000" ]]; then
         rc=404
      fi

      if [[ $rc -eq 200 ]]; then
         echo "Good News - $SITE_NAME is up - $URL"
         counter=10
      else
         echo "--ERROR-- [responseCode:$rc] $SITE_NAME is not available!"
         echo "Going to sleep for $sleepTime seconds"
         sleep $sleepTime
      fi
      counter=$((counter+1))
   done
}

cd $ES_HOME

echo "Starting ElasticSearch ... "
./bin/elasticsearch > $ELK_HOME/logs/elasticsearch.log 2>1 &

echo "Sleeping for $sleepTime before checking if its up ..."
sleep $sleepTime

check "ElasticSearch" "http://localhost:9200"

rc=$(curl -sL -k -w "%{http_code}\n" $URL -o /dev/null)

if [[ $rc -eq 200 ]]; then
   echo "Script completed successfully"
   exit 0
else
   echo "Script FAILED to start ElasticSearch"
   exit 1
fi
