---
title: "Running Tor Proxy with Docker"
date: 2020-07-05T15:45:06+05:30
tags: ["tor", "docker", "opsec", "privacy"]
favorite: true
---

Today I was testing [dns-tor-proxy][dns-tor-proxy] which required a SOCKS5 Tor proxy and realized I never ran a Tor service on my current machine. I use [Tor browser][tor-browser] almost daily for browsing websites I have absolutely no trust on, but not the standalone Tor proxy. In this article, I will try to set one up using the system package as well as inside a Docker container.

## What is a Tor proxy?

A Tor proxy is a SOCKS5 proxy which routes your traffic through the Tor network. The Tor network ensures that any traffic originating from inside the network gets routed through atleast 3 random relays before exiting through the exit node.

It helps you to anonymize traffic, block trackers and, prevent surveillance amongst other benefits. If you are wondering who should use Tor, the answer is every person who cares about their privacy. You can read more about the architecture [here][tor-architecture].

## Arch Linux

Tor is available in the Arch package repository and can be simply installed by:

```shell
# Install Tor
$ sudo pacman -S tor
...
# Start the service
$ sudo systemctl start tor

# Check whether the service is running
$ sudo netstat -tunlp | grep tor
tcp     0   0   127.0.0.1:9050  0.0.0.0:*   LISTEN  3808529/tor
```

We see above that installing `tor` through `pacman` set up the systemd service as well. Jump to [Using the proxy](#using-the-proxy) for the demo.

## Debian/Ubuntu

The packages in the Debian ecosystem are often outdated. To get the latest version, one almost always needs to add third-party package repositories. I am not going into detail how to install Tor in that ecosystem, since there are a **lot** of distribution/version combinations. The steps are well detailed in the official Tor installation [docs][tor-debian-install].

## Docker

We will be building a very lightweight Docker image to reduce footprint.

Let's start with the Tor configuration,

```shell
SocksPort 0.0.0.0:9050
```

The above should get one started with the defaults. Feel free to change the port to whatever you like. The address being listened should be `0.0.0.0` as we would be accessing the server from outside the docker container.

```dockerfile
# set alpine as the base image of the Dockerfile
FROM alpine:latest

# update the package repository and install Tor
RUN apk update && apk add tor

# Copy over the torrc created above and set the owner to `tor`
COPY torrc /etc/tor/torrc
RUN chown -R tor /etc/tor

# Set `tor` as the default user during the container runtime
USER tor

# Set `tor` as the entrypoint for the image
ENTRYPOINT ["tor"]

# Set the default container command
# This can be overridden later when running a container
CMD ["-f", "/etc/tor/torrc"]
```

Let's build the image now.

```shell
$ docker build -t palnabarun/tor .
Sending build context to Docker daemon  67.58kB
Step 1/6 : FROM alpine:latest
 ---> a24bb4013296
Step 2/6 : RUN apk update && apk add tor
 ---> Using cache
 ---> a5ea632ba987
Step 3/6 : COPY torrc /etc/tor/torrc
 ---> 5b351b9847bc
Step 4/6 : RUN chown -R tor /etc/tor
 ---> Running in 1f6950f03475
Removing intermediate container 1f6950f03475
 ---> 060ded5c532c
Step 5/6 : USER tor
 ---> Running in aa0553be76dc
Removing intermediate container aa0553be76dc
 ---> d763c1181285
Step 6/6 : ENTRYPOINT ["tor"]
 ---> Running in 97fd7f9ee693
Removing intermediate container 97fd7f9ee693
 ---> 13c889f5b018
Successfully built 13c889f5b018
Successfully tagged palnabarun/tor:latest
```

You might also be wondering what is the image size?

```shell
$ docker image ls | grep palnabarun/tor
palnabarun/tor  latest  13c889f5b018    About a minute ago 21.1MB
```

> The image is just a mere 21.1MB. Building docker images using [Alpine Linux][alpine] as base results in a very lightweight image.

Let's run the proxy.

```shell
$ docker run \
    --rm \
    --detach \
    --name tor \
    --publish 9050:9050 \ # change the port to whatever you put in the torrc
    palnabarun/tor
aef03d84628b

$ docker ps | grep tor
aef03d84628b    palnabarun/tor  "tor"   31 seconds ago  Up 30 seconds   0.0.0.0:9050->9050/tcp  tor
```

After sometime the Tor proxy will succesfully establish a Tor circuit and it will be ready to use.

The Tor config and Dockerfile can be found [here][github-repo] and there is a ready to consume image on [Docker Hub][dockerhub-repo]

## Using the proxy

Let's test whether the proxy is working correctly by some simple `curl` calls.

The request below is not going through the proxy and hence would show your ISP provided IP address.

```shell
$ curl https://check.torproject.org/api/ip
{"IsTor":false,"IP":"49.30.XX.XX"}
```

Now, if we specify the Tor proxy when making the request, the IP address would be different.

```shell
$ curl --socks5 127.0.0.1:9050 https://check.torproject.org/api/ip
{"IsTor":true,"IP":"185.220.XXX.XXX"}
```

Also, notice the value of `IsTor` in both the cases, the service running at `check.torproject.org` knows whether the traffic was routed through the Tor network.

The very same proxy can be used in your browser by going to the Network Settings and changing to a manual proxy configuration. I, however, highly recommend to use the [Tor browser][tor-browser] if you just want to browse the internet through Tor.

> Note: The IP addresses are partially redacted for privacy reasons.

---

If you are like me who cherishes reading RFCs, check out the following links

- [The original Tor design](https://svn-archive.torproject.org/svn/projects/design-paper/tor-design.pdf)
- [Tor v3 onion services protocol](https://gitweb.torproject.org/torspec.git/tree/rend-spec-v3.txt)


[dns-tor-proxy]: https://github.com/kushaldas/dns-tor-proxy
[tor-about]: https://www.torproject.org/about/history/
[tor-architecture]: https://2019.www.torproject.org/about/overview.html.en#thesolution
[tor-browser]: https://www.torproject.org/
[tor-debian-install]: https://2019.www.torproject.org/docs/debian.html.en
[tor-donate]: https://donate.torproject.org/
[alpine]: https://alpinelinux.org/
[github-repo]: https://github.com/palnabarun/tor-docker
[dockerhub-repo]: https://hub.docker.com/r/palnabarun/tor
