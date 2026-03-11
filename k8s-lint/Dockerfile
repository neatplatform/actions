FROM alpine:3.23.3

LABEL org.opencontainers.image.source="https://github.com/neatplatform/actions"
LABEL org.opencontainers.image.authors="Milad Irannejad <email_address>"

# Install required tools
RUN apk add --no-cache jq

# Install kubeconform (https://github.com/yannh/kubeconform)
RUN latest_release=$(wget -qO - https://api.github.com/repos/yannh/kubeconform/releases/latest) && \
    download_url=$(echo ${latest_release} | jq -r '.assets[] | select(.name | match("linux-amd64.tar.gz$")) | .browser_download_url') && \
    wget -q -O kubeconform.tar.gz ${download_url} && \
    tar -C /usr/local/bin/ -xf kubeconform.tar.gz kubeconform && \
    rm -rf kubeconform.tar.gz && \
    kubeconform -v

# Install kube-score (https://github.com/zegl/kube-score)
RUN latest_release=$(wget -qO - https://api.github.com/repos/zegl/kube-score/releases/latest) && \
    download_url=$(echo ${latest_release} | jq -r '.assets[] | select(.name | match("linux_amd64.tar.gz$")) | .browser_download_url') && \
    wget -q -O kube-score.tar.gz ${download_url} && \
    tar -C /usr/local/bin/ -xf kube-score.tar.gz kube-score && \
    rm -rf kube-score.tar.gz && \
    kube-score version

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
