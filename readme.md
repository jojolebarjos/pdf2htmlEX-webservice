
# pdf2htmlEX webservice container

[pdf2htmlEX](http://pdf2htmlex.blogspot.com/) is a precise PDF to HTML converter. Since the [original repository](https://github.com/coolwanglu/pdf2htmlEX) is not maintained anymore, many forks have appeared. This container is based on [this up-to-date fork](https://github.com/Rockstar04/pdf2htmlEX). This author has also made a [Dockerfile](https://github.com/oaeproject/oae-pdf2htmlEX-docker).


## Usage

```
docker build -t jojolebarjos/pdf2htmlex .
docker run -d -p 8080:8080 jojolebarjos/pdf2htmlex
```
