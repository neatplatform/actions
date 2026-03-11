FROM golang:1.26.0

LABEL org.opencontainers.image.source="https://github.com/neatplatform/actions"
LABEL org.opencontainers.image.authors="Milad Irannejad <email_address>"

# Install Codecov Uploader
RUN wget -q -O /usr/local/bin/codecov https://uploader.codecov.io/latest/linux/codecov && \
    chmod 755 /usr/local/bin/codecov

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
