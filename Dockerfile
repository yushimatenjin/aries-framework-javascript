# Note that the indy-sdk requires ubuntu 16 and some custom dependencies so we can't use node:carbon-apline like the others
FROM ubuntu:18.04 as base

# Grab dependencies via apt-get
RUN apt-get update && \
      apt-get install -y \
      software-properties-common \
      apt-transport-https \
      curl \
      build-essential \
      python2.7 \
      python-pip

# Setup nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash && \
    apt-get install nodejs -y

ARG libindy_ver=1.14.0
# Recommended way to get setup with libindy: https://github.com/hyperledger/indy-sdk#ubuntu-based-distributions-ubuntu-1604
ARG indy_stream=stable
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 68DB5E88 && \
    add-apt-repository "deb https://repo.sovrin.org/sdk/deb xenial $indy_stream" && \
    apt-get update && \
    apt-get install -y libindy=${libindy_ver}

# Setup our server
RUN mkdir www/
WORKDIR www/
ADD package.json ./
ADD . .

# setup yarn
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN cp -R $HOME/.yarn/bin .
RUN PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH" yarn install
# start it up, would like to get the server working but needs indy node etc.
CMD ["bash"]
