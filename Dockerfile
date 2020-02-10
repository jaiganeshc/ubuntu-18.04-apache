FROM ubuntu:18.04

RUN apt update
RUN apt upgrade -y
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt install -y tzdata
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN DEBIAN_FRONTEND=noninteractive apt install -y apache2 libapache2-mod-php php-mysql php-curl curl

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.2/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.2/apache2/php.ini

RUN a2enmod rewrite
RUN service apache2 restart
EXPOSE 80

RUN rm -rf /var/cache/apt/*

CMD /usr/sbin/apache2ctl -D FOREGROUND

