#!/bin/bash

# Setze den Mount-Punkt und LUKS-Container-Datei
LUKS_FILE="/opt/mpvpn/container.img"
MOUNT_POINT="/mnt/mpvpn"
LUKS_NAME="mpvpn"

# Funktion: Stealth-Modus
stealth_mode() {
  echo "Aktiviere Stealth-Modus..."
  
  # LUKS-Container öffnen
  echo "Passwort für LUKS-Container: "
  read -s password
  echo "$password" | cryptsetup luksOpen $LUKS_FILE $LUKS_NAME

  # Mounten des LUKS-Containers
  mkdir -p $MOUNT_POINT
  mount /dev/mapper/$LUKS_NAME $MOUNT_POINT

  # Umleitung von kritischen Systembefehlen
  echo "Umleiten von Befehlen wie ip route show und netstat auf /dev/null"
  alias ip="echo 'Befehl deaktiviert im Stealth-Modus.'"
  alias netstat="echo 'Befehl deaktiviert im Stealth-Modus.'"
  alias ifconfig="echo 'Befehl deaktiviert im Stealth-Modus.'"

  # System Logs auf /dev/null umleiten
  exec &>/dev/null

  # Skript ausführen, z. B. mpvpn.sh
  /mnt/mpvpn/mpvpn.sh

  # Nach Ausführung alles unmounten
  umount $MOUNT_POINT
  cryptsetup luksClose $LUKS_NAME
  echo "Stealth-Modus deaktiviert, LUKS-Container geschlossen."
}

# Stealth-Modus aktivieren
stealth_mode
