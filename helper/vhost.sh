#!/bin/sh

generateBasicVhost()
{
  local _domain=$1;
  local _email=$2;

  if [ ! -f "/etc/letsencrypt/live/$_domain/fullchain.pem" ]; then

    local vhost=$(cat vhosts/default.conf);
    vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");
    echo "$vhost" > /etc/apache2/sites-enabled/$_domain.conf;

    sudo service apache2 restart;
    sudo certbot certonly -d "$_domain" -m "$_email" --agree-tos --apache -n;

    unlink "/etc/apache2/sites-enabled/$_domain.conf";
  fi;
}

generateFsVhost()
{
  local _domain=$1;
  local _email=$2;

  generateBasicVhost "fs.$_domain" $_email;

  local vhost=$(cat vhosts/fs.conf);
  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/fs.conf;
  sudo service apache2 restart;
}

generateAdminVhost()
{
  local _domain=$1;
  local _email=$2;
  local _folderName=$3;

  generateBasicVhost "admin.$_domain" $_email;

  local vhost=$(cat vhosts/admin.conf);

  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");
  vhost=$(echo "$vhost" | sed "s/{folderName}/${_folderName}/");

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/admin.conf;
  sudo service apache2 restart;
}

generateUiVhost()
{
  local _domain=$1;
  local _email=$2;
  local _folderName=$3;

  generateBasicVhost $_domain $_email;

  local vhost=$(cat vhosts/ui.conf);
  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");
  vhost=$(echo "$vhost" | sed "s/{folderName}/${_folderName}/");

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/ui.conf;
  sudo service apache2 restart;
}

generateWwwVhost()
{
  local _domain=$1;
  local _email=$2;

  generateBasicVhost "www.$_domain" $_email;

  local vhost=$(cat vhosts/www.conf);
  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/www.conf;
  sudo service apache2 restart;
}

generateOtherVhost()
{
  local _domain=$1;

  local vhost=$(cat vhosts/other.conf);
  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/www.conf;
  sudo service apache2 restart;
}

fsKey=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13; echo);

unlink /etc/apache2/sites-enabled/000-default.conf;

step "VHost: FS";
generateFsVhost $domain $email;

step "VHost: ADMIN";
generateAdminVhost $domain $email $folderName;

step "VHost: UI";
generateUiVhost $domain $email $folderName;

step "VHost: WWW";
generateWwwVhost $domain $email;

step "VHost: OTHER";
generateOtherVhost $domain;
