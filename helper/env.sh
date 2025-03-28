step "ENV: /etc/environment";

echo "AIR_ENV=\"$environment\"" >> /etc/environment;
echo "AIR_FS_URL=\"https://fs.$domain/\"" >> /etc/environment;
echo "AIR_FS_KEY=\"$fsKey\"" >> /etc/environment;
echo "AIR_DB_DB=\"$dbName\"" >> /etc/environment;
echo "AIR_ADMIN_AUTH_ROOT_LOGIN=\"$rootLogin\"" >> /etc/environment;
echo "AIR_ADMIN_AUTH_ROOT_PASSWORD=\"$rootPassword\"" >> /etc/environment;
echo "AIR_ADMIN_TINY_KEY=\"$tinyKey\"" >> /etc/environment;

source /etc/environment;

mkdir /etc/systemd/system/apache2.service.d;
echo "[Service]" >> /etc/systemd/system/apache2.service.d/environment.conf;
echo "EnvironmentFile=/etc/environment" >> /etc/systemd/system/apache2.service.d/environment.conf;

content=$(sed '/\[Service\]/a EnvironmentFile=/etc/environment' /lib/systemd/system/supervisor.service);
printf '%s\n' "$content" > /lib/systemd/system/supervisor.service;

rootDirectory=$(realpath $(dirname $0));

echo "[program:notification]" >> /etc/supervisor/conf.d/notification.conf;
echo "user = www-data" >> /etc/supervisor/conf.d/notification.conf;
echo "command = php www/index.php route=notification" >> /etc/supervisor/conf.d/notification.conf;
echo "directory = /var/www/"$folderName >> /etc/supervisor/conf.d/notification.conf;
echo "stdout_logfile=/var/log/supervisor/notification.log" >> /etc/supervisor/conf.d/notification.conf;
echo "autorestart = true" >> /etc/supervisor/conf.d/notification.conf;
echo "autostart = true" >> /etc/supervisor/conf.d/notification.conf;

sudo systemctl daemon-reload;
sudo service supervisor stop;
sudo service apache2 restart;
