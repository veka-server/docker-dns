# Use the lightweight Alpine Linux as base image
FROM alpine:latest

# Install Unbound and other necessary packages
RUN apk add --no-cache unbound curl openssl nano bind-tools htop \
    && curl -o /etc/unbound/root.hints https://www.internic.net/domain/named.cache

# Copy the Unbound configuration file into the container
COPY unbound.conf /etc/unbound/unbound.conf

RUN unbound-anchor -a /etc/unbound/root.key
RUN ping -c 3 www.google.com

# Expose DNS ports
EXPOSE 53/udp
EXPOSE 53/tcp

# unbound-checkconf /etc/unbound/unbound.conf

# Set Unbound to run as the default command
CMD ["unbound", "-d", "-vvvv"]
