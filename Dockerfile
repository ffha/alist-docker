FROM golang:1.19-alpine as build
WORKDIR /app
ENV CC=clang CXX=clang++ AR=llvm-ar
RUN apk add --no-cache git bash curl gcc clang15 llvm15 musl-dev && ln -sf /usr/bin/lld /usr/bin/ld && git config --global advice.detachedHead false && git clone https://github.com/alist-org/alist.git . && git checkout v3.8.0
RUN bash build.sh release docker

FROM alpine
WORKDIR /opt/alist
COPY --from=build /app/bin/alist ./
RUN apk add --no-cache tini
LABEL org.opencontainers.image.description "A file list program that supports multiple storage, powered by Gin and Solidjs."
LABEL org.opencontainers.image.authors="fthasdd@090124.xyz"
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/alist/alist", "server", "--no-prefix"]
