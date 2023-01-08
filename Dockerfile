FROM golang:1.19-alpine as build
WORKDIR /app
ENV CC=clang CXX=clang++
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && apk add --no-cache git clang14 bash curl && git clone https://github.com/alist-org/alist.git . && git checkout v3.8.0 && bash build.sh release docker

FROM alpine
WORKDIR /opt/alist
COPY --from=build /app/bin/alist ./
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/alist/alist"]
