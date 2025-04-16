#!/bin/bash

set -e

echo "🔐 LUKS Setup: Automatische Installation der benötigten Pakete"

# Root-Prüfung
if [ "$EUID" -ne 0 ]; then
  echo "❌ Bitte führe dieses Skript als root aus."
  exit 1
fi

# OS erkennen
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS_FAMILY=""
  
  case "$ID" in
    almalinux|rocky|centos|rhel)
      OS_FAMILY="rhel"
      ;;
    debian|ubuntu|raspbian)
      OS_FAMILY="debian"
      ;;
    *)
      echo "❌ Nicht unterstütztes System: $ID"
      exit 1
      ;;
  esac
else
  echo "❌ /etc/os-release nicht gefunden – System nicht erkannt."
  exit 1
fi

# Installation je nach OS-Familie
if [ "$OS_FAMILY" = "rhel" ]; then
  echo "🟠 RHEL-basiertes System erkannt ($ID)."
  dnf install -y cryptsetup lvm2 util-linux

elif [ "$OS_FAMILY" = "debian" ]; then
  echo "🟢 Debian-basiertes System erkannt ($ID)."
  apt-get update
  apt-get install -y cryptsetup lvm2 util-linux
fi

# Abschlussprüfung
echo "✅ Überprüfe ob cryptsetup korrekt installiert wurde..."
if ! command -v cryptsetup &> /dev/null; then
  echo "❌ cryptsetup nicht gefunden – etwas ist schiefgelaufen."
  exit 1
fi

echo "🎉 Installation abgeschlossen. LUKS kann nun verwendet werden."
