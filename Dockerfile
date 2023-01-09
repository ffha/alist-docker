FROM golang:1.19-alpine as build
WORKDIR /app
RUN apk add --no-cache git bash curl gcc clang15 llvm15 musl-dev && ln -sf /usr/bin/lld /usr/bin/ld && git config --global advice.detachedHead false && git clone https://github.com/alist-org/alist.git . && git checkout v3.8.0
ENV CC=clang CXX=clang++ AR=llvm-ar
RUN bash build.sh release docker

FROM alpine
WORKDIR /opt/alist
COPY --from=build /app/bin/alist ./
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/alist/alist", "server", "--no-prefix"]
