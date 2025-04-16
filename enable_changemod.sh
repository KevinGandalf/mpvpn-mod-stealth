#!/bin/bash

# Setze den Mount-Punkt und LUKS-Container-Datei
LUKS_FILE="/opt/mpvpn/container.img"
MOUNT_POINT="/mnt/mpvpn"
LUKS_NAME="mpvpn"

# Funktion: Change-Modus
change_mode() {
  echo "Aktiviere Change-Modus..."
  
  # LUKS-Container öffnen
  echo "Passwort für LUKS-Container: "
  read -s password
  echo "$password" | cryptsetup luksOpen $LUKS_FILE $LUKS_NAME

  # Mounten des LUKS-Containers
  mkdir -p $MOUNT_POINT
  mount /dev/mapper/$LUKS_NAME $MOUNT_POINT

  # Hier kannst du Änderungen vornehmen, z. B. Konfiguration anpassen
  # Beispiel: /mnt/mpvpn/config.sh
  /mnt/mpvpn/config.sh

  # Nach den Änderungen alles unmounten
  umount $MOUNT_POINT
  cryptsetup luksClose $LUKS_NAME
  echo "Change-Modus deaktiviert, LUKS-Container geschlossen."
}

# Change-Modus aktivieren
change_mode
