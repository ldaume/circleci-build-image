# Pull base image
FROM  node:9-alpine

RUN \
  apk add --no-cache bash && \
  apk add --no-cache curl && \
  apk add --no-cache openssh-client
