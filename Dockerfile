FROM debian:8

MAINTAINER michimau <mauro.michielon@eea.europa.eu>

RUN apt-get -y update
RUN apt-get install -y php5 libapache2-mod-php5 php5-mapscript apache2 cgi-mapserver mapserver-bin wget unzip

COPY pmapper-demodata-4.zip /pmapper-demodata-4.zip
COPY pmapper-dev.zip /pmapper-dev.zip
RUN unzip pmapper-dev.zip
RUN cp -R /pmapper-dev/pmapper /var/www/html/

RUN unzip pmapper-demodata-4.zip
RUN mv /demodata /var/www/html/pmapper_demodata

RUN mkdir -p /var/www/html/tmp
RUN chown -R www-data:www-data /var/www/html
RUN chown -R www-data:www-data /var/log/apache2

#to make http://localhost/pmapper/map_default.phtml to work out of the box
RUN sed "s#/home/www/tmp/#/var/www/html/tmp/#g" -i /var/www/html/pmapper/config/default/pmapper_demo.map

#ADD phplocale.php /var/www/html
#ADD php.ini /etc/php.ini

CMD ["apachectl", "-D", "FOREGROUND"] 
