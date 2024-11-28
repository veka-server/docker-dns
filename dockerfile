# Utiliser une image légère de base
FROM alpine:latest

# Installer OpenSSH, socat et bash
RUN apk update && apk add --no-cache openssh socat bash sshpass

# Configuration de l'utilisateur SSH
RUN adduser -D sshuser && \
    mkdir /home/sshuser/.ssh

# Définir les variables d'environnement par défaut
ENV SSH_USER=sshuser
ENV SSH_PASSWORD=sshpassword
ENV SSH_PORT=22
ENV SSH_SERVER=remote_server
ENV LOCAL_PORT=53
ENV REMOTE_PORT=53

# Exposer le port 53 du conteneur
EXPOSE 53/udp
EXPOSE 53/tcp

# Script de démarrage pour établir le tunnel UDP via SSH
CMD echo "User: $SSH_USER, Server: $SSH_SERVER, Port: $SSH_PORT"; \
    sshpass -p $SSH_PASSWORD ssh -N -L $LOCAL_PORT:127.0.0.1:$REMOTE_PORT -p $SSH_PORT -o StrictHostKeyChecking=no $SSH_USER@$SSH_SERVER & \
    socat UDP-RECVFROM:$LOCAL_PORT,fork UDP:$SSH_SERVER:$REMOTE_PORT
