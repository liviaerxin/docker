#!/bin/bash
echo Granting $MYSQL_USER user ...
mysql -u root -p$MYSQL_ROOT_PASSWORD -e "\
  GRANT \
    FILE \
  ON *.* \
  TO '$MYSQL_USER'@'%'; \
  FLUSH PRIVILEGES; \
"