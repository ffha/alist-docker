FROM golang:bullseye as build
ADD --keep-git-dir=true https://github.com/alist-org/alist.git#v3.8.0 /app
WORKDIR /app
ADD https://github.com/alist-org/alist-web/releases/download/3.8.0/dist.tar.gz public/
RUN appName="alist" builtAt="$(date +'%F %T %z')" goVersion=$(go version | sed 's/go version //') gitAuthor=$(git show -s --format='format:%aN <%ae>' HEAD) gitCommit=$(git log --pretty=format:"%h" -1) version=$(git describe --long --tags --dirty --always) webVersion=$(wget -qO- -t1 -T2 "https://api.github.com/repos/alist-org/alist-web/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g') go build -ldflags="-s -w -X 'github.com/alist-org/alist/v3/internal/conf.BuiltAt=$builtAt' -X 'github.com/alist-org/alist/v3/internal/conf.GoVersion=$goVersion' -X 'github.com/alist-org/alist/v3/internal/conf.GitAuthor=$gitAuthor' -X 'github.com/alist-org/alist/v3/internal/conf.GitCommit=$gitCommit' -X 'github.com/alist-org/alist/v3/internal/conf.Version=$version' -X 'github.com/alist-org/alist/v3/internal/conf.WebVersion=$webVersion'" -o alist .
FROM gcr.io/distroless/base
WORKDIR /app
COPY  --from=build /app/alist alist
CMD /app/alist
