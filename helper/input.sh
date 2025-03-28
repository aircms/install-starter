projectType=$1;
dbName=$2;
domain=$3;
tinyKey=$4;
gitHubOrganization=$5;

environment="dev";
email="execrot@gmail.com";
rootLogin="root";
rootPassword="23wesdxc";

if [ ${#projectType} = 0 ]; then
  echo "Project type: 'shop' or 'starter'";
  read projectType;
fi;

if [ ${#dbName} = 0 ]; then
  echo "Database name:";
  read dbName;
fi;

if [ ${#domain} = 0 ]; then
  echo "Main domain name:";
  read domain;
fi;

if [ ${#tinyKey} = 0 ]; then
  echo "TinyMce key:";
  read tinyKey;
fi;

if [ ${#gitHubOrganization} = 0 ]; then
  echo "GitHub Organization name:";
  read gitHubOrganization;
fi;

folderName=$dbName;

echo "---------------------------------------------------------------------";
echo "Will be created:";
echo - $(green "$domain");
echo - $(green "fs.$domain");
echo - $(green "admin.$domain");
echo "---------------------------------------------------------------------";
echo "Project type:        $(green $projectType)";
echo "---------------------------------------------------------------------";
echo "Folder:              /var/www/$(green $folderName)";
echo "---------------------------------------------------------------------";
echo "Database name:       $(green $dbName)";
echo "---------------------------------------------------------------------";
echo "Environment:         $(green $environment)";
echo "---------------------------------------------------------------------";
echo "Email address:       $(green $email)";
echo "---------------------------------------------------------------------";
echo "Root login:          $(green $rootLogin)";
echo "Root password:       $(green $rootPassword)";
echo "---------------------------------------------------------------------";
echo "TinyMce key:         $(green $tinyKey)";
echo "---------------------------------------------------------------------";
echo "GitHub Organization: $(green $gitHubOrganization)";
echo "---------------------------------------------------------------------";
echo "Press [ENTER] to continue or CTRL+C to cancel";
read _confirm;
echo "---------------------------------------------------------------------";
echo "Great, Lets start!";
echo "---------------------------------------------------------------------";
