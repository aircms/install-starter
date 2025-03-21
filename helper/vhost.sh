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

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/fs.conf;
}

generateAdminVhost()
{
  local _domain=$1;
  local _email=$2;

  generateBasicVhost "admin.$_domain" $_email;

  local vhost=$(cat vhosts/admin.conf);

  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");

   printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/admin.conf;
}

generateUiVhost()
{
  local _domain=$1;
  local _email=$2;

  generateBasicVhost $_domain $_email;

  local vhost=$(cat vhosts/ui.conf);
  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/ui.conf;
}

generateWwwVhost()
{
  local _domain=$1;
  local _email=$2;

  generateBasicVhost "www.$_domain" $_email;

  local vhost=$(cat vhosts/www.conf);
  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/www.conf;
}

generateOtherVhost()
{
  local _domain=$1;

  local vhost=$(cat vhosts/other.conf);
  vhost=$(echo "$vhost" | sed "s/{domain}/${_domain}/");

  printf '%s\n' "$vhost" > /etc/apache2/sites-enabled/www.conf;
}

fsKey=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13; echo);

unlink /etc/apache2/sites-enabled/000-default.conf;

generateFsVhost $domain $email;

generateAdminVhost $domain $email;
generateUiVhost $domain $email;
generateWwwVhost $domain $email;
generateOtherVhost $domain;

sudo service apache2 restart;
