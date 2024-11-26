# Utiliser une image de base avec Debian
FROM debian:latest

# Mettre à jour les paquets et installer curl et BIND9
RUN apt-get update && apt-get install -y \
    curl \
    bind9 \
    bind9utils \
    procps \
    bind9-doc \
    dnsutils && \
    rm -rf /var/lib/apt/lists/*  # Nettoyer le cache APT pour réduire la taille de l'image

# Désactiver IPv6 en modifiant sysctl
RUN echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.conf && \
    echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.conf && \
    echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf

# Télécharger le fichier root.hints directement depuis l'URL
# RUN curl -o /usr/share/dns/root.hints https://www.internic.net/domain/named.root

# Copier le fichier de configuration BIND local dans le conteneur
COPY named.conf /etc/bind/named.conf

RUN sed -i '/options {/a \\tlisten-on-v6 { none; };' /etc/bind/named.conf.options

# Ouvrir les ports nécessaires pour DNS
EXPOSE 53/udp
EXPOSE 53/tcp

RUN chmod -R 777 /etc/bind/

#USER bind

# Démarrer BIND lorsque le conteneur se lance
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
