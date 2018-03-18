#!/bin/bash
# Install script for Harry's My Free Farm Bash Bot on GNU/Linux
# Tested on Debian Jessie, Stretch, Ubuntu 16.04.1 LTS
# and Bash on Windows 10 x64 Version 1703 Build 15063.0

STRINGS_en='{"strings":{"osnotsupported":{"text":"Sorry, only Debian Jessie and Stretch are supported for the time being. Bailing out."},"instpackages":{"text":"Installing needed packages..."},"downloadingbot":{"text":"Downloading Harrys MFF Bash Bot..."},"unpackarc":{"text":"Unpacking the archive..."},"settingpermissions":{"text":"Setting permissions..."},"conflighttpd":{"text":"Configuring lighttpd..."},"nowebserveruser":{"text":"Webserver user could not be determined. Cannot continue."},"settingupgui":{"text":"Setting up GUI files..."},"settinguplogrotate":{"text":"Setting up logrotate..."},"wannasetup":{"text":"If you do not wish for automatic bot setup, press CTRL-C now"},"enterfarm":{"text":"Please enter your farm name: "},"enterserver":{"text":"Please enter your server number: "},"enterpass":{"text":"Please enter your password for that farm: "},"gonnadothis":{"text":"This script will now set up your farm using this information:"},"farmname":{"text":"Farm name: "},"password":{"text":"Password: "},"isinfocorrect":{"text":"Is this info correct? (Y/N): "},"settingupfarm":{"text":"Setting up farm..."},"adjustini":{"text":"The preset language for this farm is GERMAN! Adjust it in config.ini."},"creatingscript":{"text":"Creating bot start script..."},"done":{"text":"Done! Start your Bot with ./startallbots.sh"}}}'
STRINGS_de='{"strings":{"osnotsupported":{"text":"Nur Debian Jessie and Stretch werden momentan unterstüzt. Abbruch."},"instpackages":{"text":"Benötigte Pakete installieren..."},"downloadingbot":{"text":"Harrys MFF Bash Bot herunterladen..."},"unpackarc":{"text":"Archiv auspacken..."},"settingpermissions":{"text":"Dateirechte setzen..."},"conflighttpd":{"text":"lighttpd konfigurieren..."},"nowebserveruser":{"text":"Der Webserver-Benutzer konnte nicht ermittelt werden. Hier endet alles."},"settingupgui":{"text":"GUI Dateien verarbeiten..."},"settinguplogrotate":{"text":"logrotate einrichten..."},"wannasetup":{"text":"Falls du keine automatische Bot-Einrichtung wuenschst, druecke jetzt STRG-C"},"enterfarm":{"text":"Bitte gib Deinen Farmnamen ein: "},"enterserver":{"text":"Bitte die passende Servernummer eingeben: "},"enterpass":{"text":"Bitte das Passwort für diese Farm eingeben: "},"gonnadothis":{"text":"Deine Farm wird mit diesen Daten angelegt:"},"farmname":{"text":"Farmname: "},"password":{"text":"Passwort: "},"isinfocorrect":{"text":"Sind die Infos korrekt? (J/N): "},"settingupfarm":{"text":"Farm einrichten..."},"adjustini":{"text":"Die voreingestellte Sprache fuer diese Farm ist DEUTSCH!"},"creatingscript":{"text":"Bot-Startskript erstellen..."},"done":{"text":"Fertig! Starte Deinen Bot mit ./startallbots.sh"}}}'
STRINGS_bg='{"strings":{"osnotsupported":{"text":"missing translation"},"instpackages":{"text":"missing translation"},"downloadingbot":{"text":"missing translation"},"unpackarc":{"text":"missing translation"},"settingpermissions":{"text":"missing translation"},"conflighttpd":{"text":"missing translation"},"nowebserveruser":{"text":"Потребителят на уеб сървър не можа да бъде определен. Не известна грешка!"},"settingupgui":{"text":"missing translation"},"settinguplogrotate":{"text":"missing translation"},"wannasetup":{"text":"Ако не желаете автоматична настройка на бота, натиснете CTRL-C"},"enterfarm":{"text":"Въведете име на ферма:"},"enterserver":{"text":"Моля, изберете номер на сървър:"},"enterpass":{"text":"missing translation"},"gonnadothis":{"text":"Този скрипт ще настрои вашата ферма използвайки:"},"farmname":{"text":"ферма: "},"password":{"text":"Password: "},"isinfocorrect":{"text":"Вярна ли е информацията? (Д/Н): "},"settingupfarm":{"text":"missing translation"},"adjustini":{"text":"Предварителният език за тази ферма е НЕМСКИ!"},"creatingscript":{"text":"missing translation"},"done":{"text":"Готово! missing translation"}}}'

if ! which jq >/dev/null 2>&1; then
 echo "Installing jq..."
 sudo apt-get install jq
 if ! which jq >/dev/null 2>&1; then
  echo -e "jq could not be found. Cannot continue.\njq konnte nicht gefunden werden. Fortfahren nicht möglich."
  exit 1
 fi
fi
JQBIN="$(which jq) -r"

while (true); do
 echo -e "\nInstallions-Sprache wählen"
 echo "Choose your install language"
 read -p "de = Deutsch, en = English, bg = Bulgarian -> " IL
 [[ "$IL" != "de" ]] || break
 [[ "$IL" != "en" ]] || break
 [[ "$IL" != "bg" ]] || break
done

TEXT=STRINGS_$IL
function getString {
 # 1 = text, 2 = parameter
 # indirect parameter expansion
 echo ${!TEXT} | $JQBIN $2 '.strings.'$1'.text'
}

if [ -f /etc/debian_version ]; then
 DVER=$(cat /etc/debian_version)
else
 getString osnotsupported
 exit 1
fi
case $DVER in
 8.*|*essie*)
  PHPV=php5-cgi
  ;;
 9.*|*tretch*)
  PHPV=php-cgi
  ;;
esac
LCONF=/etc/lighttpd/lighttpd.conf

getString instpackages
sudo apt-get update
sudo apt-get install lighttpd $PHPV screen logrotate cron unzip nano

cd
getString downloadingbot
wget "https://github.com/HackerHarry/mffbashbot/archive/master.zip"

getString unpackarc
unzip -q master.zip
mv mffbashbot-master mffbashbot
chmod 775 mffbashbot
cd ~/mffbashbot
getString settingpermissions
find . -type d -exec chmod 775 {} +
find . -type f -exec chmod 664 {} +
chmod +x *.sh

getString conflighttpd
if grep -q 'server\.document-root\s\+=\s\+"/var/www"' $LCONF; then
 sudo sed -i 's/server\.document-root\s\+=\s\+\"\/var\/www\"/server\.document-root = \"\/var\/www\/html\"/' $LCONF
 sudo mkdir -p /var/www/html
fi
HTTPUSER=$(grep server.username $LCONF | sed -e 's/.*= \"\(.*\)\"/\1/')
if [ -z "$HTTPUSER" ]; then
 getString nowebserveruser
 exit 1
fi
sudo usermod -a -G $USER $HTTPUSER 2>/dev/null
echo '
fastcgi.server = ( ".php" => ((
                     "bin-path" => "/usr/bin/'$PHPV'",
                     "socket" => "/tmp/php.socket"
                 )))
# source of all modification in order to make php5 run under
# lighttpd http://www.howtoforge.com/lighttpd_mysql_php_debian_etch ' | sudo tee --append $LCONF > /dev/null

cd /etc/lighttpd/conf-enabled/
sudo ln -s ../conf-available/10-accesslog.conf 10-accesslog.conf
sudo ln -s ../conf-available/10-fastcgi.conf 10-fastcgi.conf
if ! grep -qe 'server\.stream-response-body\s\+=\s\+1' $LCONF; then
 echo "server.stream-response-body = 1" | sudo tee --append $LCONF > /dev/null
fi

sudo /etc/init.d/lighttpd restart

getString settingupgui
cd ~/mffbashbot
sudo mv mffbashbot-GUI /var/www/html/mffbashbot
sudo chmod +x /var/www/html/mffbashbot/script/*.sh
sudo sed -i 's/\/pi\//\/'$USER'\//' /var/www/html/mffbashbot/gamepath.php
echo $HTTPUSER' ALL=(ALL) NOPASSWD: /bin/kill' | sudo tee /etc/sudoers.d/www-data-kill-cmd > /dev/null

getString settinguplogrotate
echo '/home/'$USER'/mffbashbot/*/mffbot.log
{
        rotate 6
        daily
        su '$USER' '$USER'
        missingok
        notifempty
        delaycompress
        compress
} ' | sudo tee /etc/logrotate.d/mffbashbot > /dev/null

echo
getString wannasetup
while (true); do
 echo
 # -j suppresses new line
 getString enterfarm -j
 read FARMNAME
 getString enterserver -j
 read SERVER
 getString enterpass -j
 read PASSWORD
 echo
 getString gonnadothis
 getString farmname -j
 echo $FARMNAME
 echo "Server: ${SERVER}"
 getString password -j
 echo $PASSWORD
 echo
 getString isinfocorrect -j
 read CONFIRM
 [[ "$CONFIRM" != "Y" ]] || break
 [[ "$CONFIRM" != "y" ]] || break
 [[ "$CONFIRM" != "J" ]] || break
 [[ "$CONFIRM" != "j" ]] || break
 [[ "$CONFIRM" != "Д" ]] || break
 [[ "$CONFIRM" != "д" ]] || break
done

CFGFILE=config.ini
getString settingupfarm
cd
mv mffbashbot/dummy mffbashbot/$FARMNAME
sed -i 's/server = 2/server = '$SERVER'/' mffbashbot/$FARMNAME/$CFGFILE
sed -i 's/password = \x27s3cRet!\x27/password = \x27'$PASSWORD'\x27/' mffbashbot/$FARMNAME/$CFGFILE
getString adjustini
sleep 5
echo
getString creatingscript
echo '#!/bin/bash
cd
sudo /etc/init.d/lighttpd start
cd mffbashbot
./mffbashbot.sh '$FARMNAME >startallbots.sh
chmod +x startallbots.sh

echo
getString done
sleep 5
