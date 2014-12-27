FROM phusion/baseimage:latest

MAINTAINER Maurice Kaag <mkaag@me.com>

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes
# Workaround initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

# Workaround initscripts trying to mess with /dev/shm: <https://bugs.launchpad.net/launchpad/+bug/974584>
# Used by our `src/ischroot` binary to behave in our custom way, to always say we are in a chroot.
ENV FAKE_CHROOT 1
RUN mv /usr/bin/ischroot /usr/bin/ischroot.original
ADD build/ischroot /usr/bin/ischroot

# Configure no init scripts to run on package updates.
ADD build/policy-rc.d /usr/sbin/policy-rc.d

# Disable SSH
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# BtSync Installation
ENV SECRET false
WORKDIR /usr/local/bin
RUN \
    sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 505D97A41C61B9CD; \
    apt-get update -qqy

RUN \
    apt-get install -qqy curl; \
    curl -s -o btsync.tar.gz http://download-lb.utorrent.com/endpoint/btsync/os/linux-x64/track/stable; \
    tar -zxf btsync.tar.gz && rm btsync.tar.gz; \
    chown root: /usr/local/bin -R && chmod 755 btsync; \
    mkdir -p /btsync/.sync /var/run/btsync /data

ADD build/btsync.conf /btsync/btsync.conf

RUN mkdir /etc/service/btsync
ADD build/btsync.sh /etc/service/btsync/run
RUN chmod +x /etc/service/btsync/run

EXPOSE 8888 55555
VOLUME ["/data"]
# End BtSync

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
