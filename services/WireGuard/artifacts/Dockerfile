FROM alpine:3.17.3

# Labels.
LABEL Maintainer="Renier Collazo Woo" \
      Description="WireGuard VPN on top of Alpine Linux v3.17.2"

# Install dependencies.
RUN set -euxo pipefail; \
    apk add --no-cache --no-progress \
    linux-headers \
    wireguard-tools \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

# Add Entrypoint script.
ADD ./conf/server/entrypoint.sh /usr/local/bin/
RUN chmod u+x /usr/local/bin/entrypoint.sh

# Expose ports.
EXPOSE 31777/udp

# CMD.
CMD ["entrypoint.sh"]

# wootechspace/wireguard-server:1.0.0-alpine