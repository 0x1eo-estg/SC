FROM almalinux:latest

RUN ln -fs /usr/share/zoneinfo/Europe/Lisbon /etc/localtime && \
    dnf update && dnf install -yq rrdtool apache2 mariadb-client php php-mysql php-gd php-gmp php-intl php-ldap php-mbstring php-simplexml php-xml php-snmp wget

WORKDIR /var/www/html/
RUN wget https://files.cacti.net/cacti/linux/cacti-1.2.28.tar.gz && \
    tar xzvf cacti-1.2.25.tar.gz && \
    mv cacti-1.2.25 cacti && \
    rm cacti-1.2.25.tar.gz && \
    sed -i 's/;date.timezone =/date.timezone = Europe\/Lisbon/' /etc/php/8.1/apache2/php.ini && \
    sed -i 's/;date.timezone =/date.timezone = Europe\/Lisbon/' /etc/php/8.1/cli/php.ini

COPY config.php /var/www/html/cacti/include/config.php

WORKDIR /var/www/html/cacti/
RUN chown -R www-data:www-data * && \
    echo "*/5 * * * * www-data php /var/www/html/cacti/poller.php > /dev/null 2>&1" >> /etc/crontab

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]