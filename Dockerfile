FROM mkaag/baseimage:latest
MAINTAINER Maurice Kaag <mkaag@me.com>

# -----------------------------------------------------------------------------
# Environment variables
# -----------------------------------------------------------------------------
ENV SECRET false

# -----------------------------------------------------------------------------
# Pre-install
# -----------------------------------------------------------------------------
RUN \
    sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 505D97A41C61B9CD; \
    apt-get update -qqy

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------
WORKDIR /usr/local/bin
RUN \
    apt-get install -qqy curl; \
    curl -s -o btsync.tar.gz http://download-lb.utorrent.com/endpoint/btsync/os/linux-x64/track/stable; \
    tar -zxf btsync.tar.gz && rm btsync.tar.gz; \
    chown root: /usr/local/bin -R && chmod 755 btsync; \
    mkdir -p /btsync/.sync /var/run/btsync /data

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
ADD build/btsync.conf /btsync/btsync.conf
RUN mkdir /etc/service/btsync
ADD build/btsync.sh /etc/service/btsync/run
RUN chmod +x /etc/service/btsync/run

EXPOSE 8888 55555
VOLUME ["/data"]

CMD ["/sbin/my_init"]

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

