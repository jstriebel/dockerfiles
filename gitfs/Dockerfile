FROM ubuntu:xenial

ENV DEBIAN_FRONTEND=noninteractive

RUN \
  apt-key adv --keyserver hkp://hkps.pool.sks-keyservers.net --recv-keys 3EE61981 && \
  echo "deb http://ppa.launchpad.net/presslabs/gitfs/ubuntu trusty main" > /etc/apt/sources.list.d/gitfs.list && \
  apt-get update && \
    apt-get install -y \
      gitfs \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/
