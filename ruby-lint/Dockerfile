FROM ruby:4.0.1-alpine

LABEL org.opencontainers.image.source="https://github.com/neatplatform/actions"
LABEL org.opencontainers.image.authors="Milad Irannejad <email_address>"

# Install required tools
RUN apk add --no-cache build-base

# Install RuboCop (https://github.com/rubocop/rubocop)
RUN gem install rubocop

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
