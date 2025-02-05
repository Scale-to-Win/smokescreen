# syntax=docker.io/docker/dockerfile:1.13-labs

# Loosly based on https://github.com/fly-apps/smokescreen/blob/master/Dockerfile

FROM golang:1.23.6-bookworm AS builder

WORKDIR /go/src/app
COPY --exclude=Dockerfile --exclude=acl.yaml --exclude=config.yaml . .
RUN go build .

FROM debian:bookworm-slim

COPY --from=builder /go/src/app/smokescreen /usr/local/bin/smokescreen
COPY acl.yaml /etc/smokescreen/acl.yaml
COPY config.yaml /etc/smokescreen/config.yaml

ENTRYPOINT [ "smokescreen" ]
CMD [ "--config-file", "/etc/smokescreen/config.yaml", "--egress-acl-file", "/etc/smokescreen/acl.yaml" ]

EXPOSE 4750
