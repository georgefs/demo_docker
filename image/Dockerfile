FROM ubuntu:14.04
MAINTAINER gliacloud <robot@gliacloud.com>

RUN apt-get update
RUN apt-get install -y python-pip python-dev 
ADD requirement.txt requirement.txt
RUN pip install -y requirement.txt

# default running endpoint
RUN curl https://raw.githubusercontent.com/gliacloud/deploy/new/src/run.sh -o /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh
RUN mkdir /logs
