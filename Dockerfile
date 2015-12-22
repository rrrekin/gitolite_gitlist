FROM elsdoerfer/gitolite

MAINTAINER Michal Rudewicz <michal.rudewicz@gmail.com>

RUN apt-get update
RUN apt-get -y install supervisor nginx-full php5-fpm curl
RUN apt-get autoclean

ADD https://s3.amazonaws.com/gitlist/gitlist-master.tar.gz /var/www/

RUN cd /var/www; tar -zxf gitlist-master.tar.gz
RUN chmod -R 777 /var/www/gitlist
RUN cd /var/www/gitlist/; mkdir cache; chmod 777 cache

WORKDIR /var/www/gitlist/
ADD config.ini /var/www/gitlist/config.ini
ADD nginx.conf /etc/nginx.conf

ADD sshd.conf /etc/supervisor/conf.d/sshd.conf
ADD www.conf /etc/supervisor/conf.d/www.conf
ADD fastcgi.conf /etc/php5/fpm/pool.d/www.conf
RUN rm /var/www/gitlist-master.tar.gz

EXPOSE 22 80

ENTRYPOINT ["/init", "/usr/bin/supervisord", "-n"]
