# docker-dns

 docker build -t dns https://github.com/veka-server/docker-dns.git#main; \
 docker stop dns ; docker rm dns ; \
 docker run -d --restart unless-stopped \
 --name dns \
 -p 53:53/udp \
 -p 53:53/tcp \
 dns
