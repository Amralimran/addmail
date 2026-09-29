FROM php:8.3-apache

# Install Docker CLI (client only — we talk to the host daemon via the socket)
RUN apt-get update \
    && apt-get install -y --no-install-recommends docker.io gosu \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite headers

# Copy app
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

# Startup script: match www-data's group to the docker.sock GID, then start Apache
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
