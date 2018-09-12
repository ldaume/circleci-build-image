# Pull base image
FROM  node:10-alpine

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

# Define additional metadata for our image.
VOLUME /var/lib/docker
ENTRYPOINT ["wrapdocker"]
