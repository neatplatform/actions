FROM alpine:3.23.3

LABEL org.opencontainers.image.source="https://github.com/neatplatform/actions"
LABEL org.opencontainers.image.authors="Milad Irannejad <email_address>"

# Install required tools
RUN apk add --no-cache jq

# Install shellcheck (https://github.com/koalaman/shellcheck)
RUN latest_release=$(wget -qO - https://api.github.com/repos/koalaman/shellcheck/releases/latest) && \
    version=$(echo ${latest_release} | jq -r '.tag_name') && \
    download_url=$(echo ${latest_release} | jq -r '.assets[] | select(.name | match("linux.x86_64.tar.gz$")) | .browser_download_url') && \
    wget -q -O shellcheck.tar.gz ${download_url} && \
    tar -C /usr/local/bin/ -xf shellcheck.tar.gz --strip-components=1 shellcheck-${version}/shellcheck && \
    rm -rf shellcheck.tar.gz && \
    shellcheck --version

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
