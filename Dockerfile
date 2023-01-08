FROM golang:alpine as build
WORKDIR /app
ENV CC=clang CXX=clang++
RUN apk add --no-cache git clang15 bash curl && git clone https://github.com/alist-org/alist.git . && git checkout v3.8.0 && ./build.sh release docker

FROM alpine
WORKDIR /opt/alist
COPY --from=build /app/bin/alist ./
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/alist/alist']
