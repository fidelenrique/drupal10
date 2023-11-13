dropdb  -U root drupal10db -f;
createdb  -U root drupal10db;
# add pg_trgm extension
psql -U root  drupal10db CREATE EXTENSION pg_trgm;
#psql -U root -e "create database drupal10";
psql -U root  drupal10db < /home/db/drupal10_fr.sql;
#psql -U root  drupal9db < /home/db/te_cache_products.sql;
