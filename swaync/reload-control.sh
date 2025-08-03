#!/bin/bash

# Swaync Hot-Reload Control Script
# Gerencia o daemon de auto-reload do swaync

SWAYNC_DIR="/home/ang3lo/.config/swaync"
PIDFILE="$SWAYNC_DIR/.hot-reload.pid"
DAEMON_SCRIPT="$SWAYNC_DIR/auto-reload.sh"

case "$1" in
    start)
        if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
            echo "⚠️  Hot-reload já está rodando (PID: $(cat "$PIDFILE"))"
        else
            echo "🚀 Iniciando swaync hot-reload..."
            nohup "$DAEMON_SCRIPT" >/dev/null 2>&1 &
            sleep 1
            if [[ -f "$PIDFILE" ]]; then
                echo "✅ Hot-reload iniciado (PID: $(cat "$PIDFILE"))"
            else
                echo "❌ Falha ao iniciar hot-reload"
            fi
        fi
        ;;
    stop)
        if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
            PID=$(cat "$PIDFILE")
            kill "$PID"
            rm -f "$PIDFILE"
            echo "🛑 Hot-reload parado (PID era: $PID)"
        else
            echo "⚠️  Hot-reload não está rodando"
        fi
        ;;
    status)
        if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
            echo "✅ Hot-reload está rodando (PID: $(cat "$PIDFILE"))"
        else
            echo "⚠️  Hot-reload não está rodando"
        fi
        ;;
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;
    *)
        echo "Uso: $0 {start|stop|status|restart}"
        echo ""
        echo "Comandos:"
        echo "  start   - Inicia o hot-reload daemon"
        echo "  stop    - Para o hot-reload daemon"
        echo "  status  - Mostra status do daemon"
        echo "  restart - Reinicia o daemon"
        exit 1
        ;;
esac
