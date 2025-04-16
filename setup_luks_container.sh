#!/bin/bash

# Pfade und Namen
LUKS_FILE="/opt/mpvpn/container.img"   # Container-Datei
MOUNT_POINT="/mnt/mpvpn"                # Mount-Punkt
LUKS_NAME="mpvpn"                       # LUKS-Name

# Überprüfen, ob die Container-Datei bereits existiert
if [ ! -f "$LUKS_FILE" ]; then
  # Falls nicht, erstelle eine leere Datei für den Container (z. B. 200 MB)
  echo "Erstelle LUKS-Container-Datei..."
  dd if=/dev/zero of=$LUKS_FILE bs=1M count=200
  # LUKS-Format auf der Datei anwenden
  cryptsetup luksFormat $LUKS_FILE
  echo "LUKS-Container-Datei erstellt und formatiert."
fi

# Passwort eingeben und den LUKS-Container öffnen
echo "Passwort für LUKS-Container: "
read -s password
echo "$password" | cryptsetup luksOpen $LUKS_FILE $LUKS_NAME

# Mounten des Container-Inhalts
mkdir -p $MOUNT_POINT
mount /dev/mapper/$LUKS_NAME $MOUNT_POINT

echo "LUKS-Container gemountet unter $MOUNT_POINT"

# Hier kannst du dann die Daten einfügen oder Skripte ausführen, z. B. mpvpn.sh oder Konfigurationen
# Beispiel: /mnt/mpvpn/mpvpn.sh ausführen
