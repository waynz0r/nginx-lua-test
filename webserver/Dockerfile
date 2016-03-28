FROM alpine:latest
MAINTAINER Zsolt Varga <zsolt.varga@console.hu>

RUN apk update && apk add go && rm -rf /var/cache/apk/*

ENV GOROOT /usr/lib/go
ENV GOPATH /gopath
ENV GOBIN /gopath/bin
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

ADD main.go /gopath/src/app/
RUN go get app

CMD []
ENTRYPOINT ["/gopath/bin/app"]

EXPOSE 80
