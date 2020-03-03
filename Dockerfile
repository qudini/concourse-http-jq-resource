FROM alpine:3.11

RUN apk add --update bash jq && rm -rf /var/cache/apk/*
ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
