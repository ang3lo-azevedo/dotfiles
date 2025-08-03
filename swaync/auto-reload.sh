#!/bin/bash

# Swaync Auto-Reload Service
# Este script funciona como um daemon que monitora e recarrega automaticamente o swaync

SWAYNC_DIR="/home/ang3lo/.config/swaync"
PIDFILE="$SWAYNC_DIR/.hot-reload.pid"

# Função para limpar ao sair
cleanup() {
    echo "🛑 Parando hot-reload do swaync..."
    rm -f "$PIDFILE"
    exit 0
}

# Capturar sinais de interrupção
trap cleanup SIGTERM SIGINT

# Verificar se já está rodando
if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    echo "⚠️  Hot-reload já está rodando (PID: $(cat "$PIDFILE"))"
    exit 1
fi

# Salvar PID
echo $$ > "$PIDFILE"

echo "🚀 Iniciando swaync hot-reload daemon..."
echo "📝 PID: $$"
echo "📁 Monitorando: $SWAYNC_DIR/config.json"
echo "🎨 Monitorando: $SWAYNC_DIR/style.css"

# Loop principal de monitoramento
while true; do
    # Monitorar config.json e style.css por mudanças
    CHANGED_FILE=$(inotifywait -q -e modify,moved_to --format '%w%f' "$SWAYNC_DIR/config.json" "$SWAYNC_DIR/style.css" 2>/dev/null)
    
    # Pequena pausa para evitar múltiplos reloads em sequência
    sleep 0.3
    
    TIMESTAMP=$(date '+%H:%M:%S')
    FILENAME=$(basename "$CHANGED_FILE")
    
    echo "🔄 $TIMESTAMP - $FILENAME alterado, recarregando swaync..."
    
    # Recarregar baseado no arquivo alterado
    if [[ "$CHANGED_FILE" == *"config.json" ]]; then
        swaync-client --reload-config >/dev/null 2>&1
        # Enviar notificação visual
        notify-send "Swaync" "Configuração recarregada" --icon="preferences-system" --urgency=low 2>/dev/null
    elif [[ "$CHANGED_FILE" == *"style.css" ]]; then
        swaync-client --reload-css >/dev/null 2>&1
        # Enviar notificação visual
        notify-send "Swaync" "Estilos recarregados" --icon="applications-graphics" --urgency=low 2>/dev/null
    fi
    
    echo "✅ Swaync recarregado!"
done
