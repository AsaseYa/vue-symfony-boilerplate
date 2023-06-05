### Installation
```sh
  sudo docker-compose build && \
  sudo docker-compose up -d
```

### Erase Containers && Images
```sh
  sudo docker stop $(sudo docker ps -a -q) && \
  sudo docker rm $(sudo docker ps -a -q) && \
  sudo docker image rm -f IMAGE $(sudo docker images -aq)
```

### Commands
```sh
# Docker
$ sudo docker-compose up -d
$ sudo docker-compose down
$ sudo docker-compose up -d --no-deps --build mysql
$ sudo docker-compose up -d --no-deps --build apache
$ sudo docker-compose up -d --no-deps --build php
$ sudo docker-compose exec php sh
$ sudo docker-compose exec mysql sh

# Containers
$ sudo docker ps -a -q
$ sudo docker stop $(sudo docker ps -a -q)
$ sudo docker rm $(sudo docker ps -a -q)

# Images
$ sudo docker images -a -q
$ sudo docker image rm -f IMAGE $(sudo docker images -aq)

# Symfony
$ sudo docker-compose exec php php bin/console cache:clear

# Composer
$ sudo docker-compose exec php composer install

# Yarn
$ sudo docker-compose exec php yarn
$ sudo docker-compose exec php yarn watch
```

### Utils
php bin/console lexik:jwt:generate-keypair --skip-if-exists
