# Use the lightweight Alpine Linux as base image
FROM alpine:latest

# Install Unbound and other necessary packages
RUN apk add --no-cache unbound

# Copy the Unbound configuration file into the container
COPY unbound.conf /etc/unbound/unbound.conf

# Expose DNS ports
EXPOSE 53/udp
EXPOSE 53/tcp

# Set Unbound to run as the default command
CMD ["unbound", "-d"]
