#!/bin/bash

# Swaync Hot Reload Script
# Monitora config.json e style.css e recarrega automaticamente quando houver mudanças

SWAYNC_DIR="/home/ang3lo/.config/swaync"
CONFIG_FILE="$SWAYNC_DIR/config.json"
STYLE_FILE="$SWAYNC_DIR/style.css"

echo "🔄 Iniciando hot-reload do swaync..."
echo "📁 Monitorando: $CONFIG_FILE"
echo "🎨 Monitorando: $STYLE_FILE"
echo "❌ Pressione Ctrl+C para parar"

# Função para recarregar configuração
reload_config() {
    echo "🔧 Config alterada, recarregando..."
    swaync-client --reload-config
    echo "✅ Config recarregada!"
}

# Função para recarregar CSS
reload_css() {
    echo "🎨 CSS alterado, recarregando..."
    swaync-client --reload-css
    echo "✅ CSS recarregado!"
}

# Usar inotifywait para monitorar mudanças nos arquivos
inotifywait -m -e modify,move,create "$CONFIG_FILE" "$STYLE_FILE" --format '%w%f %e' |
while read file event; do
    case "$file" in
        "$CONFIG_FILE")
            reload_config
            ;;
        "$STYLE_FILE")
            reload_css
            ;;
    esac
done
