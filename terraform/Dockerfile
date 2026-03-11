# STAGE 1: Build
FROM alpine:3.23.3 AS builder

LABEL org.opencontainers.image.source="https://github.com/neatplatform/actions"
LABEL org.opencontainers.image.authors="Milad Irannejad <email_address>"

ENV os=linux \
    arch=amd64 \
    name=terraform

# Install required tools
RUN apk add --no-cache ca-certificates gnupg unzip

COPY hashicorp.asc .
RUN regex='[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}' && \
    version=$(wget -qO - "https://releases.hashicorp.com/${name}/" | grep -oE "${name}_${regex}</a>" | grep -oE "$regex" | head -n 1) && \
    wget -q "https://releases.hashicorp.com/${name}/${version}/${name}_${version}_SHA256SUMS" && \
    wget -q "https://releases.hashicorp.com/${name}/${version}/${name}_${version}_SHA256SUMS.sig" && \
    wget -q "https://releases.hashicorp.com/${name}/${version}/${name}_${version}_${os}_${arch}.zip" && \
    gpg --import hashicorp.asc && \
    gpg --verify "${name}_${version}_SHA256SUMS.sig" "${name}_${version}_SHA256SUMS" && \
    sed -i "/${name}_${version}_${os}_${arch}.zip$/!d" "${name}_${version}_SHA256SUMS" && \
    sha256sum -c "${name}_${version}_SHA256SUMS" | grep "${name}_${version}_${os}_${arch}.zip: OK" && \
    unzip "${name}_${version}_${os}_${arch}.zip" -d /usr/local/bin/ && \
    chmod 755 "/usr/local/bin/${name}" && \
    rm "${name}_${version}_SHA256SUMS" "${name}_${version}_SHA256SUMS.sig" "${name}_${version}_${os}_${arch}.zip" && \
    terraform version

# STAGE 2: Final
FROM alpine:3.23.3

RUN apk add --no-cache make curl openssh git

COPY --from=builder "/usr/local/bin/${name}" /usr/local/bin/
COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
