include ./api/.env.local

DOCKER_COMP = docker-compose
DOCKER_COMPOSE_DEV = -f docker-compose.yml

PHP_CONT = $(DOCKER_COMP) $(DOCKER_COMPOSE_DEV) exec api
NODE_CONT = $(DOCKER_COMP) $(DOCKER_COMPOSE_DEV) exec client

# Executables
PHP      = $(PHP_CONT) php
NPM      = $(NODE_CONT) npm
SYMFONY  = $(PHP_CONT) bin/console

build:
	@$(DOCKER_COMP) $(DOCKER_COMPOSE_DEV) build --pull --build-arg NO_CACHE=0

build-no-cache:
	@$(DOCKER_COMP) $(DOCKER_COMPOSE_DEV) build --pull --no-cache

up:
	@$(eval env ?=)
	@$(eval o ?=)
	@$(DOCKER_COMP) $(DOCKER_COMPOSE_DEV) --env-file $(if $(env),$(env),'api/.env.local') up --detach $(o)

start: build up

down:
	@$(DOCKER_COMP) $(DOCKER_COMPOSE_DEV) down --remove-orphans

logs:
	@$(DOCKER_COMP) $(DOCKER_COMPOSE_DEV) logs --tail=0 --follow

php:
	@$(PHP_CONT) bash

vue:
	@$(NODE_CONT) sh

# Database
reset: ## reset database with fixtures
	@$(PHP_CONT) php bin/console doctrine:database:drop --force --if-exists;
	@$(PHP_CONT) php bin/console doctrine:database:create --if-not-exists;
	@$(PHP_CONT) php bin/console doctrine:migrations:migrate --no-interaction;
	@$(PHP_CONT) php bin/console doctrine:fixtures:load --no-interaction;

ddd: ## drop database
	@$(PHP_CONT) php bin/console doctrine:database:drop --force --if-exists;

ddc: ## create database
	@$(PHP_CONT) php bin/console doctrine:database:create --if-not-exists;

dmm: ## migrate database
	@$(PHP_CONT) php bin/console doctrine:migrations:migrate --no-interaction;

dfl: ## load fixtures
	@$(PHP_CONT) php bin/console doctrine:fixtures:load --no-interaction;

dmd: ## migration diff database
	@$(PHP_CONT) php bin/console doctrine:migrations:diff --no-interaction;

cs-fixer:
	@$(PHP_CONT) vendor/friendsofphp/php-cs-fixer/php-cs-fixer fix src --rules=@Symfony
	@$(PHP_CONT) vendor/friendsofphp/php-cs-fixer/php-cs-fixer fix tests --rules=@Symfony

twig-lint:
	@$(SYMFONY) lint:twig templates/

php-stan:
	@$(PHP_CONT) vendor/phpstan/phpstan/phpstan analyse -c config/packages/phpstan.neon --memory-limit 1G

lintfix:
	@$(NODE_CONT) npm run lint

qa:
	@make lintfix
	@make twig-lint
	@make cs-fixer
	@make php-stan

