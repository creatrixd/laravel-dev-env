FROM debian:12.8

RUN apt update && apt install -y --no-install-recommends \
    php8.2 \
    php8.2-fpm \
    php8.2-pdo \
    php8.2-pdo-sqlite \
    php8.2-zip \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-cli \
    php8.2-xml \
    unzip \
    ca-certificates \
    nginx \
    curl \
    git \
    libzip-dev \
    supervisor \
    fish \ 
    sqlite3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

RUN echo "chmod -R 777 /app" > permit.sh 
WORKDIR /app

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
