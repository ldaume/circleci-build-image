# Pull chome image
FROM  zenika/alpine-chrome

USER root
# Pull node image
FROM  node:11.15.0-alpine

USER root

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker

RUN sed -e 's;^#http\(.*\)/v3.6/community;http\1/v3.6/community;g' -i /etc/apk/repositories

RUN apk --update add \
  bash \
  iptables \
  ca-certificates \
  openssh-client \
  e2fsprogs \
  docker \
  && chmod +x /usr/local/bin/wrapdocker \
  && rm -rf /var/cache/apk/*

USER root

RUN npm install cypress -g

# Define additional metadata for our image.
VOLUME /var/lib/docker
ENTRYPOINT ["wrapdocker"]
