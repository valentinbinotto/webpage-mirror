# webpage-mirror

### Usecase

Mit dem Skript webpage-mirror.sh sollen HTML-Seiten, CSS-Files, JavaSkript-Files und Bilder unterhalb einer Domain heruntergeladen und danach auf einem Webserver abgelegt und damit Dritten zugänglich gemacht werden. <br>
Dieses Script..: <br>
- ..Hilft Zensur vorzubeugen indem man Online-Inhalte auf einen Webserver kopieren kann und so Inhalte erhalten/einsehbar bleiben. 
- ..Ermöglicht es Webseiteninhaber schnell und einfach eine Spiegelung der Originalseite zu erstellen, die bei Ausfall dieser weiterhin verfügbar ist, um weiterhin Zugang zu den Inhalten zu bieten.

### Umgebung und Automation

Das Skript ist auf dem Betriebssystem Debian 12 (bookworm) mit dem Interpreter BASH ausführbar. Folgende Voraussetzungen hat das System, auf welchem das Skript ausgeführt werden soll, zwingend zu erfüllen:

- Vorhandene Anbindung ans "Internet" bzw. Zugang zum Webserver welcher gespiegelt werden soll
- Nutzung von "apt" als Paketmanager
- Apache2 ist bereits auf dem System mit den Standartkonfigurationen installiert ODER überhaupt kein Webserver ist auf dem Betriebssystem installiert
- Port 80 wird aktuell durch Apache2 genutzt ODER Port 80 wird überhaupt nicht verwendet und ist somit aktuell frei
- Es ist keine Firewall vorhanden ODER die Firewall erlaubt den Zugriff auf Apache2 von anderen Netzwerknutzern
- Tool "wget" bereits vorhanden/installiert auf lokalem System
- Das Betriebssystem nutzt "systemd"
- Das Skript wird durch den Superuser (root) oder einen Nutzer mit Superuser-Berechtigungen via sudo ausgeführt


Das Skript verarbeitet folgende Dateien:

- HTML Code
- CSS Code
- Java Script
- Bilder

Folgende Tools/Skripte aus den Debian-Repositories werden im Skript genutzt:
- wget
- systemctl
- mv

![Aktivitätsdiagramm](/Medien/Diagramm_Design-webpage-mirror.png)


### Creators
By Valentin Binotto & Florian Fröbel - 2023

