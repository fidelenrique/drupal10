# drupal10
## Installation de docker
- Il faut au préalable avoir docker et docker-compose (ou docker compose) installés sur la machine \

- Il faut créer le fichier .env à la racine du projet et copier les variables ci-dessous :
  DATABASE_NAME=drupal10db
  DATABASE_USER=root
  DATABASE_PASS=Drup@l10!
  DATABASE_HOST=postgres
  DATABASE_PORT=5432
  ENV=local
  URL_FRONT_ACCESS=www.drupal10.fr;www.bo-drupal10.fr
  URL_BACK_ACCESS=localhost;127.0.0.1


## Lancement des services docker
Lancement des services avec docker-compose
Lancer la commade :
```
docker-compose up --build -d
```
## Importer la base de données
Pour importer la base de données, un Dump de base de données est présent dans le répertoire du projet \
docker/bdd-postgres. Ce répertoire est un volume partagé avec le container d10-postgres. \
Pour importer la base de données via le container,  il faut d'abord se connecter au container d10-postgres. \

1- Lancer la commande :
```
docker exec -it d10-postgres /bin/bash
```
2- Se placer dans le répertoire du volume partagé. \
Dans le container, lancer la commande :
```
cd /home/db
```
3- Importer la base de donnée Drupal en lançant la commande :  \
Dans le container, lancer la commande :
```
./drupal_upload.sh
```
Une fois, l'import terminé, vous pouvez lancer la commande 'exit' pour quitter le container.

Installer les dépendances du projet avec la commande :
```
composer install
```
## Interface pgAdmin
```
http://localhost:9080/browser/
  'database' => 'drupal10db',
  'username' => 'root',
  'password' => 'Drup@l10!',

## Accès à l'IHM
L'IHM est accessible à l'adresse https://localhost/
Login de test : fidel
Mot de passe : f

