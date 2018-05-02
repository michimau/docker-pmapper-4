# docker-pmapper-4

PMAPPER 4 in docker sauce

you may want to harden your httpd/php configurations before going in production.

git clone https://github.com/michimau/docker-pmapper-4.git
cd docker-pmapper-4
docker build -t pmapper .
docker run -p 80:80 --rm --name pmapper pmapper

visit: http://localhost/pmapper/map_default.phtml?config=default
