FROM ubuntu:22.04

LABEL version="1.0"

ARG APP_PORT
ARG ODBC_DRIVER_SCRIPT
ARG OPENSSL_UPDATER

ENV ACCEPT_EULA=Y

# Copy into to image the file of the ODBC Driver installation
RUN mkdir /opt/ODBC_Driver
COPY $ODBC_DRIVER_SCRIPT /opt/ODBC_Driver/

# Copy into to image the file of the ODBC Driver installation
RUN mkdir /opt/openssl_updater
COPY $OPENSSL_UPDATER /opt/openssl_updater/

# Update apt-get and Add new repository
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install software-properties-common -y \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update    

# Setting Timezone
RUN apt-get install -y tzdata \
    && ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata

# Installing PHP 8.2 and some extensions
# Install CURL as well
RUN apt-get install php8.2 -y \
    && apt-get install -y \
    php8.2-cli \
    php8.2-common \
    php8.2-fpm \ 
    php8.2-zip \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-curl \
    php8.2-xml \
    php8.2-bcmath \
    php8.2-mysql \
    php8.2-ldap \
    && apt-get -y install mysql-client \
    && apt-get install curl -y \
    && apt-get install -y unzip wget

# Installing ODBC Driver
RUN sh /opt/ODBC_Driver/install_ODBC_Driver.sh

# Installing SQL Server Driver for PHP
RUN apt-get install php-pear \
    && apt-get install php8.2-dev -y \
    && apt-get install unixodbc-dev -y \
    && pecl install sqlsrv \
    && pecl install pdo_sqlsrv \
    && sed -i '/extension=odbc/a\extension=sqlsrv' /etc/php/8.2/cli/php.ini \
    && echo "extension=pdo_sqlsrv.so" >>  /etc/php/8.2/apache2/conf.d/30-pdo_sqlsrv.ini \
    && echo "extension=pdo_sqlsrv.so" >>  /etc/php/8.2/cli/conf.d/30-pdo_sqlsrv.ini \
    && echo "extension=pdo_sqlsrv.so" >>  /etc/php/8.2/fpm/conf.d/30-pdo_sqlsrv.ini

# Updating OPENSSL 
RUN sh /opt/openssl_updater/install_openssl.sh

# Settings for Apache
RUN echo "ServerName docker_localhost" >> /etc/apache2/apache2.conf \
    && a2enmod rewrite && chown -R www-data:www-data /var/www

# Installing Composer to manager PHP dependencies
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && sed -i 's/;curl.cainfo =/curl.cainfo = null/g' /etc/php/8.2/apache2/php.ini \
    && sed -i 's/;curl.cainfo =/curl.cainfo = null/g' /etc/php/8.2/cli/php.ini \
    && sed -i 's/;curl.cainfo =/curl.cainfo = null/g' /etc/php/8.2/fpm/php.ini

# Setting for USER on the system and Apache
ENV APACHE_RUN_USER www-data ENV APACHE_RUN_GROUP www-data ENV APACHE_LOG_DIR /var/log/apache2

WORKDIR /var/www/html

# To define the port will be exposed
EXPOSE $APP_PORT

# To make Apache keep running in background
CMD apachectl -D FOREGROUND

# /opt/mssql-tools18/bin/sqlcmd -S 10.101.40.120,1433 -U laudo -P 123456789 -C -Q 'select @@version'
# nano /etc/odbc.ini
# [NomeDSN]
# Driver = ODBC Driver 17 for SQL Server
# Server = 10.101.40.120
