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
    php8.3 \
    php8.3-fpm \
    php8.3-pdo \
    php8.3-pdo-sqlite \
    php8.3-pdo-mysql \
    php8.3-zip \
    php8.3-mbstring \
    php8.3-curl \
    php8.3-cli \
    php8.3-xml \
    php8.3-bcmath \
    php8.3-intl \
    php8.3-gd \
    php8.3-mysqli \
    php8.3-soap \
    php8.3-xmlrpc \
    php8.3-opcache \
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
