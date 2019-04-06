FROM appsvcorg/nginx-fpm:php7.2.13

RUN apk add --no-cache  --update --virtual buildDeps \
	libc-dev \
	make \
	gcc  \
	autoconf \
	freetype \
	libpng \
	libjpeg-turbo \
	freetype-dev \
	libpng-dev \
	libjpeg-turbo-dev && \
	docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
	NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
	docker-php-ext-install -j${NPROC} gd && \
	apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN cd /usr/local/bin/ && \
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
  php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
  php composer-setup.php && \
  php -r "unlink('composer-setup.php');" && \
  mv composer.phar composer
