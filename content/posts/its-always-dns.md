---
title: "It's always DNS!"
date: 2020-06-30
tags: ["devops", "kubernetes", "coredns", "kind", "debugging", "dns"]
---

## Context

I was running [Airflow][airflow] inside a Kubernetes cluster but the Airflow pods were not able to connect with the PostgreSQL database running inside the cluster. The following was consistently seen in the Airflow logs, although the `postgres-airflow` service was up and running.

```text
sqlalchemy.exc.OperationalError: (psycopg2.OperationalError) could not translate host
name "postgres-airflow" to address: Temporary failure in name resolution
```

For the rest of this post, we will assume that all the user run components inside the cluster are running perfectly and focus on what is causing the name resolution errors.

## The whole story

I use [kind][kind] for testing and playing around with Kubernetes workloads. I spin up clusters with any specific Kubernetes version as and when needed. The Kubernetes cluster I spun up was running Kubernetes 1.15.7 using the following KinD configuration.

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.15.7@sha256:e2df133f80ef633c53c0200114fce2ed5e1f6947477dbc83261a6a921169488d
- role: worker
  image: kindest/node:v1.15.7@sha256:e2df133f80ef633c53c0200114fce2ed5e1f6947477dbc83261a6a921169488d
- role: worker
  image: kindest/node:v1.15.7@sha256:e2df133f80ef633c53c0200114fce2ed5e1f6947477dbc83261a6a921169488d
```

> I know that this is a deprecated version on Kubernetes. But, since the workloads I am testing will be deployed on GKE, I need to get to the closest upstream configuration.

Digging deeper using `dig` (Yes! That was intentional), I found that pods inside the cluster were not able to communicate with each other using the Kubernetes Service Discovery and even to the outside world.

```shell
debug ~ $ dig postgres-airflow.default.svc.cluster.local

; <<>> DiG 9.11.5-P4-5.1+deb10u1-Debian <<>> postgres-airflow.default.svc.cluster.local
;; global options: +cmd
;; connection timed out; no servers could be reached

debug ~ $ dig naba.run

; <<>> DiG 9.11.5-P4-5.1+deb10u1-Debian <<>> naba.run
;; global options: +cmd
;; connection timed out; no servers could be reached
```

Pinging the pod/service IP was working fine which meant issues with kube-proxy can be eliminated. The next thing came to my mind was DNS. It's always DNS right? :wink:

![It's always DNS](/images/its-always-dns.png)
> Image Source: https://www.reddit.com/r/sysadmin/comments/34ag51/its_always_dns/

Looking at the CoreDNS pods, it was pretty evident that they are erroring out and something wrong is happening.

```shell
$ kubectl -n kube-system get pods -l k8s-app=kube-dns
NAME                                            READY   STATUS             RESTARTS   AGE
coredns-5d4dd4b4db-kmmsf                        0/1     CrashLoopBackOff   262        22h
coredns-5d4dd4b4db-lnqjb                        0/1     CrashLoopBackOff   262        22h
```

Next, I fetched logs of one of the pods.

```shell
$ kubectl -n kube-system logs coredns-5d4dd4b4db-lnqjb
.:53
2020-06-30T07:24:33.638Z [INFO] CoreDNS-1.3.1
2020-06-30T07:24:33.639Z [INFO] linux/amd64, go1.11.4, 6b56a9c
CoreDNS-1.3.1
linux/amd64, go1.11.4, 6b56a9c
2020-06-30T07:24:33.639Z [INFO] plugin/reload: Running configuration MD5 = 5d5369fbc12f985709b924e721217843
2020-06-30T07:24:33.641Z [FATAL] plugin/loop: Loop (127.0.0.1:59596 -> :53) detected for zone ".", see https://coredns.io/plugins/loop#troubleshooting. Query: "HINFO 41198296958627012.1538475969163399818."
```

Voila! The error itself pointed me to the troubleshooting documentation. This kind of error logging is pretty rare to be honest and I would love to see it in more projects.

Coming back to the problem at hand, the [loop][coredns-loop] plugin detects DNS forwarding loops and raises an error. Now, in order to see why a loop is forming, we have to look at the CoreDNS configuration.

```text
.:53 {
    errors
    health
    kubernetes cluster.local in-addr.arpa ip6.arpa {
       pods insecure
       upstream
       fallthrough in-addr.arpa ip6.arpa
       ttl 30
    }
    prometheus :9153
    forward . /etc/resolv.conf
    cache 30
    loop
    reload
    loadbalance
}
```

So, any DNS request to this CoreDNS server is first processed by the [kubernetes][coredns-kubernetes] plugin and if the domain name does not match the in cluster domain patterns, the request is forwarded to the next plugin in the chain, which in this case is [forward][coredns-forward]. This is a pretty simplified explanation about what is happening. A detailed explanation can be found in the [CoreDNS manual][coredns-plugins].

`forward . /etc/resolv.conf` configures the forward plugin to use the hosts resolver configuration for DNS resolution. Let's have a look at what it is in that file.

```shell
$ kubectl -n kube-system cp coredns-5d4dd4b4db-lnqjb:/etc/resolv.conf resolv.conf
error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "c3d8909904e9c6ced0a41e73133c1f6acf5517edd29ed866918dc3001eb6df02": OCI runtime exec failed: exec failed: container_linux.go:346: starting container process caused "exec: \"tar\": executable file not found in $PATH": unknown
```

Bummer! The CoreDNS docker image used here doesn't have the tools we need to find the files. But, let's try to inspect the CoreDNS deployment. Kubernetes has a way to define what would be the contents of `/etc/resolv.conf` and that is the `dnsPolicy` field in a container specification. (More on this in later articles)

```shell
$ kubectl -n kube-system get deployments/coredns  -o yaml | grep "dnsPolicy"
      dnsPolicy: Default
```

When `dnsPolicy` is set to `Default`, the containers use DNS configuration of the Kubernetes node they are sheduled to. KinD runs all the nodes as Docker containers. Let's see what's in there:

```shell
$ docker ps
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                       NAMES
a561ebab4938        kindest/node:v1.15.7   "/usr/local/bin/entr…"   30 hours ago        Up 30 hours                                     airflow-worker2
7150659a691a        kindest/node:v1.15.7   "/usr/local/bin/entr…"   30 hours ago        Up 30 hours         127.0.0.1:35725->6443/tcp   airflow-control-plane
f2f2e47b4a41        kindest/node:v1.15.7   "/usr/local/bin/entr…"   30 hours ago        Up 30 hours                                     airflow-worker

$ docker exec airflow-control-plane cat /etc/resolv.conf
nameserver 127.0.0.11
options ndots:0
```

The nameserver specified is a localhost loopback which is implying that the resolver for the hosts _aka Kubernetes node_ is CoreDNS itself. This creates a circular dependency in DNS resolution and that is caught by the CoreDNS loop plugin.

I resorted to a quick fix by changing the recursive resolver used by CoreDNS to 8.8.8.8, by modifiying the Corefile as follows and restarting CoreDNS.

```text
 .:53 {
     errors
     health
     kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        upstream
        fallthrough in-addr.arpa ip6.arpa
        ttl 30
     }
     prometheus :9153
-    forward . /etc/resolv.conf
+    forward . 8.8.8.8
     cache 30
     loop
     reload
     loadbalance
 }
```

CoreDNS pods are now running without errors and DNS resolution is working as expected.

```shell
debug ~ # dig +short postgres-airflow.default.svc.cluster.local
10.98.135.99
```

Now, the fix I did is not the perfect one. Any new containers created by Kubernetes with `dnsPolicy: Default` will still face the same issue. The ideal way is to ask the resolver in the OS distribution used for nodes to not use localhost loopback for DNS resolution or use a custom resolver configuration and specifying the path to kubelet.

## Final Thoughts

It was fun trying to dive up into the problem and understand the basics of why DNS resolution was failing.

The whole debugging process is meant to describe a thought process how you can debug an issue like this in a complex system. Straight forward answers can be found in the debugging sections [here][kubernetes-dns-debugging] and [here][coredns-loop].

[airflow]: https://airflow.apache.org
[kind]: https://kind.sigs.k8s.io
[coredns-loop]: https://coredns.io/plugins/loop
[coredns-kubernetes]: https://coredns.io/plugins/kubernetes
[coredns-forward]: https://coredns.io/plugins/forward
[coredns-plugins]: https://coredns.io/manual/toc/#plugins
[kubernetes-dns-debugging]: https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/#known-issues
