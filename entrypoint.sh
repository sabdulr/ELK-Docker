#!/bin/bash

## ELK Stack Download ##
TAR_DIR=/home/elk/installables
ELK_HOME=/home/elk
LOGDIR=/home/elk/logs
LOGFILE=$LOGDIR/entrypoint.log

mkdir -p $TAR_DIR
mkdir -p $LOGDIR
cd $TAR_DIR 

echo "Downloading Kibana ..." | tee -a $LOGFILE
wget https://artifacts.elastic.co/downloads/kibana/kibana-oss-7.10.1-linux-x86_64.tar.gz -P $TAR_DIR | tee -a $LOGFILE

echo "Downloading ElasticSearch ..." | tee -a $LOGFILE
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-7.10.1-linux-x86_64.tar.gz -P $TAR_DIR | tee -a $LOGFILE

echo "Untarring Kibana ..." | tee -a $LOGFILE
tar zxvf kibana-oss-7.10.1-linux-x86_64.tar.gz -C $ELK_HOME | tee -a $LOGFILE

echo "Untarring ElastcSearch ..." | tee -a $LOGFILE
tar zxvf elasticsearch-oss-7.10.1-linux-x86_64.tar.gz -C $ELK_HOME | tee -a $LOGFILE

cp /home/elk/config/kibana.yml /home/elk/kibana-7.10.1-linux-x86_64/config/.
cp /home/elk/config/elasticsearch.yml /home/elk/elasticsearch-7.10.1/config/.


echo "Setting permissions ..." | tee -a $LOGFILE
chown -R elk:elk $ELK_HOME
chmod -R 775 $ELK_HOME

echo "Calling script to start ElasticSearch ..." | tee -a $LOGFILE
su elk -c "/bin/bash /home/elk/scripts/start_es.sh" | tee -a $LOGFILE

sleep 5

echo "Calling script to start Kibana ..." | tee -a $LOGFILE
su elk -c "/bin/bash /home/elk/scripts/start_kibana.sh" | tee -a $LOGFILE

echo "Starting infinish loop ..." | tee -a $LOGFILE
while [ true ]
do
  #echo "Going to sleep"
  sleep 86400
  #echo "Time to wake up"
  #echo ""
done


