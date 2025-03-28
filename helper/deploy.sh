#!/bin/sh

rootDirectory=$(realpath $(dirname $0));

step "Deploying: $projectType to $foldername";
mkdir "/var/www/$folderName";
cd "/var/www/$folderName";

git clone "git@github.com:$gitHubOrganization/$projectType.git" .;

export COMPOSER_ALLOW_SUPERUSER=1;
composer update;
composer run-script assets;

step "Deploying: FS";
mkdir /var/www/fs;
cd /var/www/fs;

git clone "git@github.com:$gitHubOrganization/fs.git" .;

export COMPOSER_ALLOW_SUPERUSER=1;
composer update;
composer run-script assets;
composer run-script storage;

cd $rootDirectory;


