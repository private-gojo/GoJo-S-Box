FROM alpine:3.21 AS downloader

ARG SINGBOX_VERSION=1.13.8
ARG TARGETARCH=amd64

RUN apk add --no-cache wget ca-certificates && \
    wget -qO /tmp/sb.tar.gz \
        "https://github.com/SagerNet/sing-box/releases/download/v${SINGBOX_VERSION}/sing-box-${SINGBOX_VERSION}-linux-${TARGETARCH}.tar.gz" && \
    tar -xzf /tmp/sb.tar.gz -C /tmp && \
    mv /tmp/sing-box-${SINGBOX_VERSION}-linux-${TARGETARCH}/sing-box /sing-box && \
    chmod +x /sing-box && \
    rm -rf /tmp/*

FROM alpine:3.21

LABEL maintainer="private-gojo" \
      version="1.13.8" \
      description="Sing-box VLESS WS Cloud Run"

RUN apk add --no-cache ca-certificates

COPY --from=downloader /sing-box /sing-box
COPY config.json /etc/sing-box/config.json

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/sing-box", "run", "-c", "/etc/sing-box/config.json"]

