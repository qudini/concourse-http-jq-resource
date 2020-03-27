FROM alpine:3.11

RUN apk add --update bash jq wget && \
  rm -rf /var/cache/apk/* && \
  mkdir -p /opt/resource/logs/
ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
