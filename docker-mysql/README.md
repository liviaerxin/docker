ref: https://hub.docker.com/_/mysql/
docker pull mysql
$ docker run --name mysql -e MYSQL_ROOT_PASSWORD=passw0rd -p 3306:3306 -d mysql
