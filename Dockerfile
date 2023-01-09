FROM golang:1.19-alpine as build
WORKDIR /app
RUN apk add --no-cache git bash curl clang15 musl-dev fortify-headers llvm145 libgcc lld && ln -s /usr/bin/lld /usr/bin/ld && git clone https://github.com/alist-org/alist.git . && git checkout v3.8.0
ENV CC=clang CXX=clang++ AR=llvm14-ar
RUN bash build.sh release docker

FROM alpine
WORKDIR /opt/alist
COPY --from=build /app/bin/alist ./
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/alist/alist"]
