# Utiliser une image de base avec Debian
FROM debian:latest

# Mettre à jour les paquets et installer curl et BIND9
RUN apt-get update && apt-get install -y \
    curl \
    bind9 \
    bind9utils \
    bind9-doc \
    dnsutils && \
    rm -rf /var/lib/apt/lists/*  # Nettoyer le cache APT pour réduire la taille de l'image

# Télécharger le fichier root.hints directement depuis l'URL
# RUN curl -o /usr/share/dns/root.hints https://www.internic.net/domain/named.root

# Copier le fichier de configuration BIND local dans le conteneur
COPY named.conf /etc/bind/named.conf

# Ouvrir les ports nécessaires pour DNS
EXPOSE 53/udp
EXPOSE 53/tcp

# Démarrer BIND lorsque le conteneur se lance
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
