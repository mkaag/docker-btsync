## BtSync Dockerfile

This repository contains the **Dockerfile** and the configuration file of [BitTorrent Sync](http://www.getsync.com/) for [Docker](https://www.docker.com/).

### Base Docker Image

* [phusion/baseimage](https://github.com/phusion/baseimage-docker), the *minimal Ubuntu base image modified for Docker-friendliness*...
* ...[including image's enhancement](https://github.com/racker/docker-ubuntu-with-updates) from [Paul Querna](https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/)

### Installation

```bash
docker build -t mkaag/btsync github.com/mkaag/docker-btsync
```

### Usage

```bash
docker run -d -p 55555:55555 -v /opt/data:/data -e "SECRET=1234567890" mkaag/btsync
```

> Note that the Web UI is disabled in the config file.
> If you do not specify the SECRET env variable, a new one will be generated.
