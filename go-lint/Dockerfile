FROM golang:1.26.0

LABEL org.opencontainers.image.source="https://github.com/neatplatform/actions"
LABEL org.opencontainers.image.authors="Milad Irannejad <email_address>"

# Install golangci-lint (https://github.com/golangci/golangci-lint)
RUN wget -q -O - https://golangci-lint.run/install.sh | sh -s latest

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
