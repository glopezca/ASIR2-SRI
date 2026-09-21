FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends apache2 curl \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /srv/www/asir
COPY index.html /srv/www/asir/index.html
COPY asir.conf /etc/apache2/sites-available/asir.conf
RUN a2dissite 000-default.conf \
 && a2ensite asir.conf \
 && sed -i 's/^Listen 80$/Listen 80/' /etc/apache2/ports.conf \
 && apache2ctl configtest
EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
