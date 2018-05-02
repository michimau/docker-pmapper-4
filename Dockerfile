FROM centos:7

MAINTAINER michimau <mauro.michielon@eea.europa.eu>

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y mapserver php php-mapserver httpd curl wget unzip vim  php-mbstring

RUN wget http://www.pmapper.net/dl/pmapper-dev.zip
RUN unzip pmapper-dev.zip
RUN cp -R /pmapper-dev/pmapper /var/www/html/

RUN echo '<FilesMatch "\.ph(p[2-6]?|tml)$">' >> /etc/httpd/conf/httpd.conf
RUN echo '    SetHandler application/x-httpd-php'  >> /etc/httpd/conf/httpd.conf
RUN echo '</FilesMatch>'  >> /etc/httpd/conf/httpd.conf

RUN wget https://netix.dl.sourceforge.net/project/pmapper/p.mapper%20demo%20data/p.mapper%20demo%20data%204/pmapper-demodata-4.zip
RUN unzip pmapper-demodata-4.zip 
RUN mv /demodata /var/www/html/pmapper_demodata

RUN mkdir -p /var/www/html/tmp
RUN chown -R apache:apache /var/www/html
RUN chown -R apache:apache /var/log/httpd

#to make http://localhost/pmapper/map_default.phtml to work out of the box
RUN sed "s#/home/www/tmp/#/var/www/html/tmp/#g" -i /var/www/html/pmapper/config/default/pmapper_demo.map

#ADD phplocale.php /var/www/html
#ADD php.ini /etc/php.ini

CMD ["apachectl", "-D", "FOREGROUND"] 
