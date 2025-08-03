#!/bin/bash

# Script simples de hot-reload para swaync (inspirado no start-waybar.sh)
# Monitora mudanças nos arquivos de configuração e recarrega automaticamente

# Função para cleanup
cleanup() {
    echo "Parando hot-reload do swaync..."
    exit 0
}

trap cleanup EXIT INT TERM

echo "🔄 Hot-reload do swaync iniciado"

# Loop de monitoramento - simples como o da waybar
while inotifywait -q -e modify,moved_to ~/.config/swaync/config.json ~/.config/swaync/style.css 2>/dev/null; do
    echo "Recarregando swaync..."
    swaync-client --reload-config >/dev/null 2>&1
    swaync-client --reload-css >/dev/null 2>&1
done
