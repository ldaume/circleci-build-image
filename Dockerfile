# Pull base image
FROM  node:9-alpine

RUN \
  apk update && \
  apk add --no-cache bash && \
  apk add --no-cache curl && \
  apk add --no-cache openssh-client && \
  apk add docker && \
  rc-update add docker boot
