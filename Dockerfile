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