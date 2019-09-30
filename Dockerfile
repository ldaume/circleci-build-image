# Pull base image
FROM  node:12-alpine

# install chromium
#RUN sed -e 's;^#http\(.*\)/v3.6/community;http\1/v3.6/community;g' -i /etc/apk/repositories

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk --no-cache update && \
    apk add --no-cache --virtual .build-deps gifsicle pngquant optipng libjpeg-turbo-utils udev ttf-opensans && \
    apk add --no-cache python alpine-sdk chromium-chromedriver chromium xvfb udev yarn bash iptables ca-certificates openssh-client e2fsprogs docker && \
    npm cache clean --force && \    
    rm -rf /var/cache/apk /root/.npm/

ENV DISPLAY=:99 CHROME_BIN=/usr/bin/chromium-browser LIGHTHOUSE_CHROMIUM_PATH=/usr/bin/chromium-browser

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
RUN chmod +x /usr/local/bin/wrapdocker  


# Define additional metadata for our image.
VOLUME /var/lib/docker
ENTRYPOINT ["wrapdocker"]
