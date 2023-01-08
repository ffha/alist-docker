FROM golang:1.19-alpine as build
WORKDIR /app
ENV CC=clang CXX=clang++
RUN apk add --no-cache git clang14 bash curl musl-dev lld libgcc && ln -s /usr/bin/lld /usr/bin/ld && git clone https://github.com/alist-org/alist.git . && git checkout v3.8.0 && bash build.sh release docker

FROM alpine
WORKDIR /opt/alist
COPY --from=build /app/bin/alist ./
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/alist/alist"]
