FROM alpine:latest

RUN apk add --update bash jq && rm -rf /var/cache/apk/*
ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
RUN mkdir /opt/resource/logs/
