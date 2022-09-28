# ctfd-gcp

An IaaC deployment of [CTFd](https://ctfd.io/) in Google Cloud Platform, intended to be reliable and easily scalable for larger CTFs. Inspired by [DownUnderCTF/ctfd-appengine](https://github.com/DownUnderCTF/ctfd-appengine).

Used for pwned3 CTF. More details on the pwned3 infrastructure [here](https://www.atteniemi.com/ctf-infra/).

### Architecture Overview

CTFd is deployed on App Engine Flex, which provides load balancing, auto-scaling, health checks and more right out of the box.

The application resides on a VPC which has a direct peering connection to a Memorystore Redis, allowing us connect CTFd to a cache that, again, requires very little manual maintenance.

There is also a private services access connection to Cloud SQL which is used as the database for CTFd. Again, scaling and other operation are easy.

CTFd stores uploaded challenge files in a Google Storage Bucket.

Furthermore, both the Memorystore and Cloud SQL are assigned only private IP addresses within our VPC, making inaccessible from the internet and enhancing security.

![](docs/architecture_overview.svg)

NOTE: this diagram is missing i.e. buckets used for challenge storage and buckets storing the CTFd Dockerfile
