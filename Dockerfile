FROM docker.io/library/golang:alpine AS source

RUN adduser --disabled-password --gecos "" \
    --home "/none" --no-create-home \
    --shell "/sbin/nologin" --uid "2222" "sysop"

WORKDIR $GOPATH/src/github.com/christiantragesser/alderaan
ADD main.go .
ADD go.mod .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' -a \
    -o /go/bin/alderaan

FROM scratch as publish
COPY --from=source /etc/passwd /etc/passwd
COPY --from=source /etc/group /etc/group
COPY --from=source /go/bin/alderaan /bin/httpd
COPY html /html

USER sysop

ENTRYPOINT ["/bin/httpd"]