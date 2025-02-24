FROM debian:12.8

RUN apt update && apt install -y --no-install-recommends \
    curl \
    libzip-dev \
    unzip \
    apt-transport-https \
    lsb-release \
    ca-certificates

RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'


RUN apt update && apt install -y --no-install-recommends \
    php8.4 \
    php8.4-fpm \
    php8.4-pdo \
    php8.4-pdo-sqlite \
    php8.4-pdo-mysql \
    php8.4-zip \
    php8.4-mbstring \
    php8.4-curl \
    php8.4-cli \
    php8.4-xml \
    php8.4-bcmath \
    php8.4-intl \
    php8.4-gd \
    php8.4-mysqli \
    php8.4-soap \
    php8.4-xmlrpc \
    php8.4-opcache \
    nginx \
    git \
    supervisor \
    fish \
    nano \
    sqlite3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm composer-setup.php

RUN echo "chmod -R 777 /app" > permit.sh 
WORKDIR /app

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
