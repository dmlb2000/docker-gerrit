# Gerrit Docker Container

This repository is used to build a gerrit docker container.

There's a few dependencies:

 - SMTP Email Server
 - MySQL Endpoint (for now)

I'd suggest wrapping this docker container with your own 
```gerrit.config``` and ```secure.config```.
