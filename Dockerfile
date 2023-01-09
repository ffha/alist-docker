FROM golang:1.19-alpine as build
WORKDIR /app
RUN apk add --no-cache git bash curl clang14 musl-dev fortify-headers 11vm14 libgcc && ln -s /usr/bin/lld /usr/bin/ld && git clone https://github.com/alist-org/alist.git . && git checkout v3.8.0
ENV CC=clang CXX=clang++ AR=llvm14-ar 

FROM alpine
WORKDIR /opt/alist
COPY --from=build /app/bin/alist ./
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/alist/alist"]
