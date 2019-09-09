# Pull base image
FROM  node:12-alpine

# Install npm-check-updates
RUN npm i -g npm-check-updates

# Install Cypress
ENV CI=1
ARG CYPRESS_VERSION="3.4.1"

RUN echo "whoami: $(whoami)"
RUN npm config -g set user $(whoami)
RUN npm install -g "cypress@${CYPRESS_VERSION}"

# Cypress cache and installed version
RUN cypress cache path
RUN cypress cache list

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
