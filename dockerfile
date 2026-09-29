FROM php:8.3-apache

# Install prerequisites for adding Docker's official repo
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
    && rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key and repo (Trixie is supported)
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian trixie stable" > /etc/apt/sources.list.d/docker.list

# Install Docker CLI (client only — daemon lives on the host)
RUN apt-get update \
    && apt-get install -y --no-install-recommends docker-ce-cli \
    && rm -rf /var/lib/apt/lists/*

# Match www-data's group to the socket's GID (yours is 988)
RUN groupadd -g 988 dockersock && usermod -aG dockersock www-data

# Enable Apache modules
RUN a2enmod rewrite headers

# Copy app
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
