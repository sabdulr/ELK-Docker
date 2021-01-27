FROM ubuntu:18.04

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-8-jdk && \
    apt-get install -y ant git vim dos2unix curl wget zip unzip  bash && \
    apt-get clean 

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

ENV ELK_HOME /home/elk

#RUN adduser -s /bin/bash -d /home/elk --disabled-password --gecos '' elk
RUN useradd -ms /bin/bash elk
WORKDIR /home/elk

RUN mkdir -p /home/elk  && \
    mkdir -p /home/elk/scripts && \
    mkdir -p /home/elk/logs && \
    mkdir -p /home/elk/pid && \
    mkdir -p /home/elk/config

# Other env variables
ENV HOME /home/elk

COPY entrypoint.sh /home/elk/scripts/entrypoint.sh
COPY start_es.sh /home/elk/scripts/start_es.sh
COPY start_kibana.sh /home/elk/scripts/start_kibana.sh
COPY ./config/kibana.yml /home/elk/config/kibana.yml
COPY ./config/elasticsearch.yml /home/elk/config/elasticsearch.yml

RUN chown -R elk:elk /home/elk && \
    chmod -R 775 /home/elk && \
    export ES_HOME="$ELK_HOME/elasticsearch-7.10.1" && \
    export KIBANA_HOME="$ELK_HOME/kibana-7.10.1-linux-x86_64" 


ENTRYPOINT [ "sh", "-c", "/home/elk/scripts/entrypoint.sh" ]

