FROM drupalci/php-5.3.29-apache:production

MAINTAINER michimau <mauro.michielon@eea.europa.eu>


ENV MAPSERVERVERSION rel-6-4-5
RUN apt-get -y update

RUN apt-get install -y \
    locales \
    locales-all \
    git \
    vim \
    build-essential \
    cmake \
    libfcgi-dev \
    fcgiwrap \
    nginx \
    libcairo2-dev \
    libpixman-1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libharfbuzz-dev \
    libexempi-dev \
    apache2-dev \
    libapr1-dev \
    libaprutil1-dev \
    libxslt1-dev \
    ruby-dev \
    librsvg2-dev \
    libgif-dev \ 
    libgdal-dev \
    libproj-dev \
    swig \
    python-dev \
    ruby-dev \
    ruby

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /tmp
RUN git clone https://github.com/mapserver/mapserver.git
WORKDIR /tmp/mapserver
RUN  git checkout $MAPSERVERVERSON

RUN mkdir build 
WORKDIR /tmp/mapserver/build

RUN cmake -DCMAKE_PREFIX_PATH=/usr/local \
    -DWITH_APACHE_MODULE=OFF \
    -DWITH_CAIRO=ON \
    -DWITH_CAIROSVG=ON \
    -DWITH_CLIENT_WFS=ON \
    -DWITH_CLIENT_WMS=ON \
    -DWITH_CSHARP=OFF \
    -DWITH_CURL=ON \
    -DWITH_EXEMPI=ON \
    -DWITH_FCGI=ON \
    -DWITH_FRIBIDI=ON \
    -DWITH_GDAL=ON \
    -DWITH_GENERIC_NINT=ON \
    -DWITH_GEOS=ON \
    -DWITH_GIF=ON \
    -DWITH_HARFBUZZ=ON \
    -DWITH_ICONV=ON \
    -DWITH_JAVA=OFF \
    -DWITH_KML=ON \
    -DWITH_LIBXML2=ON \
    -DWITH_MSSQL2008=OFF \
    -DWITH_MYSQL=ON \
    -DWITH_OGR=ON \
    -DWITH_ORACLESPATIAL=OFF \
    -DWITH_ORACLE_PLUGIN=OFF \
    -DWITH_PERL=ON \
    -DWITH_PHP=ON \
    -DWITH_PIXMAN=ON \
    -DWITH_POINT_Z_M=ON \
    -DWITH_POSTGIS=ON \
    -DWITH_PROJ=ON \
    -DWITH_PYTHON=ON \
    -DWITH_RSVG=ON\
    -DWITH_RUBY=ON \
    -DWITH_SOS=ON \
    -DWITH_SVGCAIRO=OFF\
    -DWITH_THREAD_SAFETY=ON \
    -DWITH_V8=OFF \
    -DWITH_WCS=ON \
    -DWITH_WFS=ON \
    -DWITH_WMS=ON \
    -DWITH_XMLMAPFILE=ON \
    ../

RUN cpu_count=$( grep processor /proc/cpuinfo | wc -l )
RUN make -j${cpu_count}
RUN make -j${cpu_count} install

RUN echo "deb http://www.pmapper.net/dl/debian binary/" >> /etc/apt/sources.list
RUN apt-get -y update

RUN apt-get install -y --force-yes pmapper-4.3 pmapper-demodata apt-utils

RUN apt-get install -y zendframework
RUN mv /var/www/pmapper-4* /var/www/html/pmapper
RUN mv /var/www/pmapper_d* /var/www/html/pmapper_demodata
ADD databrowser /var/www/html/databrowser/

ADD phpinfo.php /var/www/html
ADD sessions.ini /tmp/sessions.ini

ADD php.ini /usr/local/etc/php/php.ini 
ADD mapscript.ini /usr/local/etc/php/conf.d

RUN chown -R www-data:www-data /var/www/html

RUN chown -R www-data:www-data /var/log/apache2
#RUN chmod 755 /var/log/apache2


RUN cp /usr/lib/php5/20131226/php_mapscript.so /var/lib/php5/modules
ADD phplocale.php /var/www/html

CMD ["apachectl", "-D", "FOREGROUND"] 
