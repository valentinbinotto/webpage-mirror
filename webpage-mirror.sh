#!/bin/bash
# Valentin Binotto & Florian Fröbel - 2023


# Importieren von Variabeln aus entsprechender Datei
. $(dirname $0)/variables.bash

# Nutzen von wget mit entsprechenden Optionen um Dateien von Website (übergeben als erstes Argument) zu downloaden
wget -mkxKE --directory-prefix=$tempdir --output-file=$logfile -e robots=off $1
if [[ $? -ne 0 ]] ; then
    echo "Beim Ausführen des Schrittes 'wget' ist ein Fehler aufgetreten. Skript wird beendet und nicht weiter ausgeführt. Bitte prüfe ob 'wget' installiert ist und prüfe ob die Webseite, welche du beim Ausführen des Skripts angegeben hast, online verfügbar ist." >> $logfile
    exit 1
fi

# Prüfen ob Apache2 schon auf System installiert
systemctl start apache2 >> $logfile
if [[ $? -ne 0 ]] ; then
    echo "Apache2 noch nicht installiert. Wird nun durch Skript via APT installiert." >> $logfile
    # Aktualisieren der Paketquellen von apt
    apt update >> $logfile
    if [[ $? -ne 0 ]] ; then
    echo "Beim Aktualisiseren der Paketquellen ist ein Fehler aufgetreten. Bitte prüfe ob eine Internetverbindung besteht und ob gültige Paketquellen in /etc/apt/sources.list vorhanden sind. Das Skript wird nicht weiter ausgeführt." >> $logfile
    exit 2
    fi
    # Installieren von Apache2 via apt
    apt install -y apache2 >> $logfile
    if [[ $? -ne 0 ]] ; then
    echo "Beim Installieren des Apache2 Webservers ist ein Fehler aufgetreten. Das Skript wird nicht weiter ausgeführt." >> $logfile
    exit 3
    fi
    # Automatisches Starten von Apache2 bei Systemboot aktivieren und Apache2 neustarten
    systemctl enable apache2 && systemctl restart apache2 >> $logfile
    if [[ $? -ne 0 ]] ; then
    echo "Beim Verwalten des Services Apache2 mit systemctl ist ein Fehler aufgetreten. Bitte prüfe ob dein System wirklich systemd nutzt. Das Skript wird nicht weiter ausgeführt." >> $logfile
    exit 4
    fi

else
    echo "Apache2 ist bereits installiert." >> $logfile
    
fi

# Prüfen ob Standart-Apache2 HTML-File vorhanden und falls ja, löschen
if [ -f $apachewebdir/index.html ]; then
    rm $apachewebdir/index.html >> $logfile
    echo "Apache2 Standart-HTML-File wurde gelöscht" >> $logfile
    if [[ $? -ne 0 ]] ; then
       echo "Beim Löschen der Standard-HTML-File im Apache2 Ordner ist ein Fehler aufgetreten. Dieser Fehler wird ignoriert und das Skript weiter ausgeführt." >> $logfile
    fi
fi

# Verschieben der Webfiles vom temporären Ordner in den Ordner für Webcontent von Apache2
mv $tempdir/* $apachewebdir/ >> $logfile
if [[ $? -ne 0 ]] ; then
    echo "Beim Verschieben der heruntergeladenen Dateien aus $tempdir nach $apachewebdir ist ein Fehler aufgetreten. Das Skript wird nicht weiter ausgeführt." >> $logfile
exit 5
fi

# Neustarten des Webservers
systemctl restart apache2 >> $logfile
if [[ $? -ne 0 ]] ; then
    echo "Beim Neustarten des Apache2 Webservers ist ein Fehler aufgetreten. Das Skript wird nicht weiter ausgeführt." >> $logfile
exit 6
fi

# Information das Skript erfolgreich durchlaufen wurde und Hinweise, wie Mirror nun besucht werden kann
echo "Skript wurde erfolgreich ausgeführt. Der Mirror ist abrufbar unter http://127.0.0.1/ORIGINAL_DOMAIN
Eine Übersicht über sämtliche Mirrors gespiegelt auf diesem Apache2-Webserver findet sich unter http://127.0.0.1" >> $logfile
echo "-----PROZESS ERFOLGREICH BEENDET-----" >> $logfile
